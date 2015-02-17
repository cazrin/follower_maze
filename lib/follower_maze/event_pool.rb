class FollowerMaze::EventPool
  def initialize
    @events = {}
    @next_id = 1
  end

  def add(event)
    @events[event.id] = event

    while !@events[@next_id].nil?
      event = @events.delete(@next_id)
      event.process
      @next_id += 1
    end
  end
end
