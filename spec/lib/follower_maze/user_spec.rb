require "spec_helper"
require "follower_maze/user"

RSpec.describe FollowerMaze::User do
  subject { described_class.new(id: 1, connection: "socket") }

  describe "#initialize" do
    it "sets the provided ID" do
      expect(subject.id).to eq(1)
    end

    it "sets the provided connection" do
      expect(subject.connection).to eq("socket")
    end

    it "sets followers to a blank array" do
      expect(subject.followers).to eq([])
    end
  end

  describe "#add_follower" do
    it "adds the User ID to the array of followers" do
      subject.add_follower(123)
      expect(subject.followers).to eq([123])
    end
  end
end
