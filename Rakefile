require_relative "lib/follower_maze"

$stdout.sync = true

task :default do
  event_server = FollowerMaze::EventServer.new(9090)
  user_server = FollowerMaze::UserServer.new(9099)

  [event_server, user_server].map do |server|
    Thread.new { server.start }
  end.each(&:join)
end
