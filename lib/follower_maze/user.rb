class FollowerMaze::User
  attr_accessor :id, :connection, :followers

  def initialize(id:, connection: nil)
    self.id = id
    self.connection = connection
    self.followers = []
  end

  def add_follower(id)
    self.followers << id
  end
end
