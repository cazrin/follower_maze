require "spec_helper"

RSpec.describe FollowerMaze::EventPool do
  describe "#add" do
    it "adds the event to the pool" do
      event = double(id: 123)
      subject.add(event)
      expect(subject.instance_variable_get("@events")).to eq({123 => event})
    end

    context "when the added event has the next ID" do
      let(:event) { double(id: 1, process: true) }

      it "processes the event" do
        expect(event).to receive(:process)
        subject.add(event)
      end

      it "removes the event from the pool" do
        subject.add(event)
        expect(subject.instance_variable_get("@events")).to eq({})
      end

      it "increments the next ID" do
        subject.add(event)
        expect(subject.instance_variable_get("@next_id")).to eq(2)
      end
    end

    context "when the added event does not have the next ID" do
      let(:event) { double(id: 2, process: true) }

      it "does not process the event" do
        expect(event).not_to receive(:process)
        subject.add(event)
      end

      it "does not remove the event from the pool" do
        subject.add(event)
        expect(subject.instance_variable_get("@events")).to eq({2 => event})
      end

      it "does not increment the next ID" do
        subject.add(event)
        expect(subject.instance_variable_get("@next_id")).to eq(1)
      end
    end

    context "when an event is added that is the next ID and there are other events in the pool" do
      let(:event) { double(id: 1, process: true) }
      let(:event2) { double(id: 2, process: true) }
      let(:event3) { double(id: 3, process: true) }
      let(:event5) { double(id: 5, process: true) }

      before do
        subject.add(event5)
        subject.add(event3)
        subject.add(event2)
      end

      it "processes the events that are in sequence" do
        expect(event).to receive(:process)
        expect(event2).to receive(:process)
        expect(event3).to receive(:process)
        expect(event5).not_to receive(:process)

        subject.add(event)
      end

      it "removes the processed events from the pool" do
        subject.add(event)
        expect(subject.instance_variable_get("@events")).to eq({5 => event5})
      end

      it "increments the next ID" do
        subject.add(event)
        expect(subject.instance_variable_get("@next_id")).to eq(4)
      end
    end
  end
end
