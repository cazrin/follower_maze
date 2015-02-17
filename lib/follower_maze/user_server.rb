require "socket"

class FollowerMaze::UserServer
  def initialize(port)
    @port = port
  end

  def start
    server = TCPServer.new("127.0.0.1", @port)

    while socket = server.accept do
      user_id = socket.gets.strip.to_i
      FollowerMaze::UserPool.update_or_create(user_id, socket)
    end

    server.close
  end
end
