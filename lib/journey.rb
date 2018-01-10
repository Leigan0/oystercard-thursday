class Journey
  attr_reader :entry_station

  def start(entry_station)
    @entry_station = entry_station
  end
end
