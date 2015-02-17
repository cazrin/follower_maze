require "socket"

class FollowerMaze::EventServer
  def initialize(port)
    @port = port
  end

  def start
    server = TCPServer.new("127.0.0.1", @port)

    socket = server.accept

    while line = socket.gets do
      p "Event: #{line}"
    end

    server.close
  end
end
