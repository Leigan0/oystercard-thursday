class Journey
  attr_reader :entry_station, :exit_station

  def initialize
    @complete = false
  end

  def complete?
    @complete
  end

  def start(entry_station)
    @entry_station = entry_station
  end

  def complete(exit_station)
    @exit_station = exit_station
    @complete = true if @entry_station
  end

end
