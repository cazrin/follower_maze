class FollowerMaze::UserPool
  @@users = []

  class << self
    def connected_users
      @@users.reject { |user| user.connection.nil? }
    end

    def find(id)
      user = @@users.find { |user| user.id == id }
      user = update_or_create(id) if user.nil?
      user
    end

    def update_or_create(id, connection=nil)
      user = @@users.find { |user| user.id == id }

      if user.nil?
        user = FollowerMaze::User.new(id: id, connection: connection)
        @@users << user
      else
        user.connection = connection unless connection.nil?
      end

      user
    end

    def users
      @@users
    end
    def users=(users)
      @@users = users
    end
  end
end
