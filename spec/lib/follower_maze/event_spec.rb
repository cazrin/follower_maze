require "spec_helper"
require "follower_maze/event"

RSpec.describe FollowerMaze::Event do
  describe ".create_from_payload" do
    let(:event) {
      FollowerMaze::Event.create_from_payload(payload)
    }

    context "for a follow event" do
      let(:payload) { "666|F|60|50" }

      it "creates a FollowEvent" do
        expect(event).to be_a(FollowerMaze::FollowEvent)
        expect(event.id).to eq(666)
        expect(event.from).to eq(60)
        expect(event.to).to eq(50)
      end
    end

    context "for an unfollow event" do
      let(:payload) { "1|U|12|9" }

      it "creates an UnfollowEvent" do
        expect(event).to be_a(FollowerMaze::UnfollowEvent)
        expect(event.id).to eq(1)
        expect(event.from).to eq(12)
        expect(event.to).to eq(9)
      end
    end

    context "for a broadcast event" do
      let(:payload) { "542532|B" }

      it "creates an BroadcastEvent" do
        expect(event).to be_a(FollowerMaze::BroadcastEvent)
        expect(event.id).to eq(542532)
      end
    end

    context "for a private message event" do
      let(:payload) { "43|P|32|56" }

      it "creates an PrivateMessageEvent" do
        expect(event).to be_a(FollowerMaze::PrivateMessageEvent)
        expect(event.id).to eq(43)
        expect(event.from).to eq(32)
        expect(event.to).to eq(56)
      end
    end

    context "for a status update event" do
      let(:payload) { "634|S|32" }

      it "creates an StatusUpdateEvent" do
        expect(event).to be_a(FollowerMaze::StatusUpdateEvent)
        expect(event.id).to eq(634)
        expect(event.from).to eq(32)
      end
    end
  end
end
