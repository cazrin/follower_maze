class FollowerMaze::User
  attr_accessor :id, :connection, :followers

  def initialize(id:, connection: nil)
    @id = id
    @connection = connection
    @followers = []
  end

  def add_follower(id)
    @followers << id
  end

  def notify(payload)
    @connection.puts payload unless @connection.nil?
  end

  def remove_follower(id)
    @followers = @followers.reject { |follower_id| follower_id == id }
  end
end
