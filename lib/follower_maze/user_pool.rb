class FollowerMaze::UserPool
  @@users = []

  class << self
    def find(id)
      @@users.find { |user| user.id == id }
    end

    def update_or_create(id, connection=nil)
      user = find(id)

      if user.nil?
        @@users << FollowerMaze::User.new(id: id, connection: connection)
      else
        user.connection = connection
      end
    end

    def users
      @@users
    end
    def users=(users)
      @@users = users
    end
  end
end
