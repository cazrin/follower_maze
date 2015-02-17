require "spec_helper"
require "follower_maze/user_pool"

RSpec.describe FollowerMaze::UserPool do
  subject { described_class }

  after :each do
    described_class.users = []
  end

  describe ".connected_users" do
    it "returns the array of users who are connected" do
      subject.update_or_create(1, "socket")
      subject.update_or_create(2, "socket")
      subject.update_or_create(3, "socket")
      subject.update_or_create(4)

      expect(subject.connected_users.map(&:id)).to eq([1,2,3])
    end
  end

  describe ".find" do
    context "when a User with the ID exists" do
      let(:user) { FollowerMaze::User.new(id: 123) }

      before do
        subject.users = [user]
      end

      it "returns the User" do
        expect(subject.find(123)).to eq(user)
      end
    end

    context "when a User with the ID does not exist" do
      it "returns nil" do
        expect(subject.find(456)).to be_nil
      end
    end
  end

  describe ".update_or_create" do
    context "when a User with that ID exists" do
      before do
        subject.update_or_create(1)
      end

      it "updates the User's connection" do
        subject.update_or_create(1, "socket")
        expect(subject.users.count).to eq(1)

        user = subject.users.first
        expect(user.id).to eq(1)
        expect(user.connection).to eq("socket")
      end
    end

    context "when a User with that ID does not exist" do
      it "adds a User with the ID and connection to the pool" do
        subject.update_or_create(1, "socket")
        expect(subject.users.count).to eq(1)

        user = subject.users.first
        expect(user.id).to eq(1)
        expect(user.connection).to eq("socket")
      end
    end
  end

  describe ".users" do
    it "returns the array of users in the pool" do
      subject.users = [1,2,3]
      expect(subject.users).to eq([1,2,3])
    end
  end
end
