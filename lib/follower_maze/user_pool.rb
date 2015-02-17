class FollowerMaze::UserPool
  @@users = {}

  class << self
    def connected_users
      @@users.map(&:last).select(&:connected?)
    end

    def find(id)
      @@users[id] || update_or_create(id)
    end

    def update_or_create(id, connection=nil)
      if @@users[id].nil?
        user = FollowerMaze::User.new(id: id, connection: connection)
        @@users[id] = user
      else
        @@users[id].connection = connection unless connection.nil?
      end

      @@users[id]
    end

    def users
      @@users
    end
    def users=(users)
      @@users = users
    end
  end
end
