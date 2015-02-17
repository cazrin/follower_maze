require "spec_helper"
require "follower_maze/user_pool"

RSpec.describe FollowerMaze::UserPool do
  subject { described_class }

  after :each do
    described_class.users = {}
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
        subject.users = { 123 => user }
      end

      it "returns the User" do
        expect(subject.find(123)).to eq(user)
      end
    end

    context "when a User with the ID does not exist" do
      it "creates the User" do
        expect(subject.find(456)).to eq(subject.users[456])
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

        user = subject.users[1]
        expect(user.id).to eq(1)
        expect(user.connection).to eq("socket")
      end
    end

    context "when a User with that ID does not exist" do
      it "adds a User with the ID and connection to the pool" do
        subject.update_or_create(1, "socket")
        expect(subject.users.count).to eq(1)

        user = subject.users[1]
        expect(user.id).to eq(1)
        expect(user.connection).to eq("socket")
      end
    end
  end
end
