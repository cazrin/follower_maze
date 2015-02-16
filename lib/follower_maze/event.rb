module FollowerMaze
  class Event
    EVENT_MAP = {
      "B" => "BroadcastEvent",
      "F" => "FollowEvent",
      "P" => "PrivateMessageEvent",
      "S" => "StatusUpdateEvent",
      "U" => "UnfollowEvent"
    }

    attr_reader :id

    def self.create_from_payload(payload)
      id, type, from, to = payload.split("|")

      klass_name = "FollowerMaze::#{EVENT_MAP[type]}"
      klass = Object.const_get(klass_name)
      klass.new(id: id, from: from, to: to)
    end

    def initialize(attrs)
      attrs.reject! {|k,v| v.nil? }

      attrs.each do |k, v|
        self.instance_variable_set("@#{k}", v.to_i)
      end
    end
  end

  class BroadcastEvent < Event
  end

  class FollowEvent < Event
    attr_reader :from, :to
  end

  class PrivateMessageEvent < Event
    attr_reader :from, :to
  end

  class StatusUpdateEvent < Event
    attr_reader :from
  end

  class UnfollowEvent < Event
    attr_reader :from, :to
  end
end
