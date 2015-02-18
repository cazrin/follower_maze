require "spec_helper"

RSpec.describe FollowerMaze::Event do
  describe ".create_from_payload" do
    let(:event) {
      FollowerMaze::Event.create_from_payload(payload)
    }

    context "for a follow event" do
      let(:payload) { "666|F|60|50" }

      it "creates a FollowEvent" do
        expect(event).to be_a(FollowerMaze::FollowEvent)
        expect(event.payload).to eq(payload)
        expect(event.id).to eq(666)
        expect(event.from).to eq(60)
        expect(event.to).to eq(50)
      end
    end

    context "for an unfollow event" do
      let(:payload) { "1|U|12|9" }

      it "creates an UnfollowEvent" do
        expect(event).to be_a(FollowerMaze::UnfollowEvent)
        expect(event.payload).to eq(payload)
        expect(event.id).to eq(1)
        expect(event.from).to eq(12)
        expect(event.to).to eq(9)
      end
    end

    context "for a broadcast event" do
      let(:payload) { "542532|B" }

      it "creates an BroadcastEvent" do
        expect(event).to be_a(FollowerMaze::BroadcastEvent)
        expect(event.payload).to eq(payload)
        expect(event.id).to eq(542532)
      end
    end

    context "for a private message event" do
      let(:payload) { "43|P|32|56" }

      it "creates an PrivateMessageEvent" do
        expect(event).to be_a(FollowerMaze::PrivateMessageEvent)
        expect(event.payload).to eq(payload)
        expect(event.id).to eq(43)
        expect(event.from).to eq(32)
        expect(event.to).to eq(56)
      end
    end

    context "for a status update event" do
      let(:payload) { "634|S|32" }

      it "creates an StatusUpdateEvent" do
        expect(event).to be_a(FollowerMaze::StatusUpdateEvent)
        expect(event.payload).to eq(payload)
        expect(event.id).to eq(634)
        expect(event.from).to eq(32)
      end
    end
  end
end

RSpec.describe FollowerMaze::BroadcastEvent do
  describe "#process" do
    subject { described_class.new(payload: payload) }

    let(:connected_user) { FollowerMaze::UserPool.update_or_create(1, "connection") }
    let(:connected_user2) { FollowerMaze::UserPool.update_or_create(2, "connection") }
    let(:disconnected_user) { FollowerMaze::UserPool.update_or_create(1) }
    let(:payload) { "542532|B" }

    it "notifies the connected users with the payload" do
      expect(connected_user).to receive(:notify).with(payload)
      expect(connected_user2).to receive(:notify).with(payload)
      expect(disconnected_user).not_to receive(:notify).with(payload)

      subject.process
    end
  end
end

RSpec.describe FollowerMaze::FollowEvent do
  describe "#process" do
    subject { described_class.new(payload: payload, from: "60", to: "50") }

    let(:payload) { "666|F|60|50" }
    let(:from) { FollowerMaze::UserPool.update_or_create(60) }
    let(:to) { FollowerMaze::UserPool.update_or_create(50) }

    it "adds the 'from' User as a follower of the 'to' User" do
      subject.process
      expect(to.followers).to eq([60])
    end

    it "notifies the 'to' User with the payload" do
      expect(to).to receive(:notify).with(payload)
      subject.process
    end
  end
end

RSpec.describe FollowerMaze::PrivateMessageEvent do
  describe "#process" do
    subject { described_class.new(payload: payload, from: "32", to: "56") }

    let(:payload) { "43|P|32|56" }
    let(:to) { FollowerMaze::UserPool.update_or_create(56) }

    it "notifies the 'to' User with the payload" do
      expect(to).to receive(:notify).with(payload)
      subject.process
    end
  end
end

RSpec.describe FollowerMaze::StatusUpdateEvent do
  describe "#process" do
    subject { described_class.new(payload: payload, from: "32") }

    let(:payload) { "634|S|32" }
    let(:follower) { FollowerMaze::User.new(id: 1) }
    let(:follower2) { FollowerMaze::User.new(id: 2) }
    let(:from) { FollowerMaze::User.new(id: 32) }

    before do
      from.add_follower(follower.id)
      from.add_follower(follower2.id)

      FollowerMaze::UserPool.users[32] = from
      FollowerMaze::UserPool.users[1] = follower
      FollowerMaze::UserPool.users[2] = follower2
    end

    it "notifies each of the 'from' User's followers with the payload" do
      expect(follower).to receive(:notify).with(payload)
      expect(follower2).to receive(:notify).with(payload)

      subject.process
    end
  end
end

RSpec.describe FollowerMaze::UnfollowEvent do
  describe "#process" do
    subject { described_class.new(from: "12", to: "9") }

    let(:to) { FollowerMaze::User.new(id: 9) }

    before do
      to.add_follower(12)
      FollowerMaze::UserPool.users = {9 => to}
    end

    it "removes the 'from' User as a follower of the 'to' User" do
      subject.process
      expect(to.followers).to eq([])
    end
  end
end
