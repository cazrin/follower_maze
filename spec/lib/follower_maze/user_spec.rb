require "spec_helper"

RSpec.describe FollowerMaze::User do
  subject { described_class.new(id: 1, connection: "socket") }

  describe "#connected?" do
    context "when connection has a value" do
      it "returns true" do
        expect(subject).to be_connected
      end
    end

    context "when connection is nil" do
      before do
        subject.connection = nil
      end

      it "returns false" do
        expect(subject).not_to be_connected
      end
    end
  end

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

  describe "#notify" do
    context "when the connection exists" do
      let(:connection) { double(puts: true) }

      before do
        subject.connection = connection
      end

      it "sends the connection the payload" do
        expect(connection).to receive(:puts).with("payload")
        subject.notify("payload")
      end
    end
  end

  describe "#remove_follower" do
    it "removes the User ID from the array of followers" do
      subject.add_follower(123)
      subject.add_follower(456)
      subject.remove_follower(123)
      expect(subject.followers).to eq([456])
    end
  end
end
