require "socket"

class FollowerMaze::EventServer
  def initialize(port)
    @port = port
    @pool = FollowerMaze::EventPool.new
  end

  def start
    server = TCPServer.new("127.0.0.1", @port)

    socket = server.accept

    while line = socket.gets do
      event = FollowerMaze::Event.create_from_payload(line.strip)
      @pool.add(event)
    end

    server.close
  end
end
