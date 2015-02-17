require "socket"

class FollowerMaze::UserServer
  def initialize(port)
    @port = port
  end

  def start
    server = TCPServer.new("127.0.0.1", @port)

    while socket = server.accept do
      user_id = socket.gets.strip
      FollowerMaze::UserPool.add(user_id)
    end

    server.close
  end
end
