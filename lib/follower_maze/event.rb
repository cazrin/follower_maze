module FollowerMaze
  class Event
    EVENT_MAP = {
      "B" => "BroadcastEvent",
      "F" => "FollowEvent",
      "P" => "PrivateMessageEvent",
      "S" => "StatusUpdateEvent",
      "U" => "UnfollowEvent"
    }

    attr_reader :id, :payload

    def self.create_from_payload(payload)
      id, type, from, to = payload.split("|")

      klass_name = "FollowerMaze::#{EVENT_MAP[type]}"
      klass = Object.const_get(klass_name)
      klass.new(payload: payload, id: id, from: from, to: to)
    end

    def initialize(attrs)
      attrs.reject! {|k,v| v.nil? }

      attrs.each do |k, v|
        value = k == :payload ? v : v.to_i
        self.instance_variable_set("@#{k}", value)
      end
    end
  end

  class BroadcastEvent < Event
    def process
      FollowerMaze::UserPool.connected_users.each do |user|
        user.notify(@payload)
      end
    end
  end

  class FollowEvent < Event
    attr_reader :from, :to

    def process
      user = FollowerMaze::UserPool.find(@to)

      user.add_follower(@from)
      user.notify(@payload)
    end
  end

  class PrivateMessageEvent < Event
    attr_reader :from, :to

    def process
      user = FollowerMaze::UserPool.find(@to)
      user.notify(@payload)
    end
  end

  class StatusUpdateEvent < Event
    attr_reader :from

    def process
      user = FollowerMaze::UserPool.find(@from)

      user.followers.each do |follower_id|
        follower = FollowerMaze::UserPool.find(follower_id)
        follower.notify(@payload)
      end
    end
  end

  class UnfollowEvent < Event
    attr_reader :from, :to

    def process
      user = FollowerMaze::UserPool.find(@to)
      user.remove_follower(@from)
    end
  end
end
