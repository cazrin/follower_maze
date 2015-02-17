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

  def notify(payload)
    self.connection.puts payload unless self.connection.nil?
  end

  def remove_follower(id)
    self.followers = self.followers.reject { |follower_id| follower_id == id }
  end
end
