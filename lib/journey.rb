class Journey
  attr_reader :entry_station, :exit_station
  MINIMUM_FARE = 1
  PENALTY_FARE = 6

  # def initialize
  #   @entry_station = nil
  #   # @exit_station = nil
  # end

  def complete?
    @entry_station && @exit_station
  end

  def fare
    complete? ? MINIMUM_FARE : PENALTY_FARE
  end

  def origin(entry_station)
    @entry_station = entry_station
  end

  def destination(exit_station)
    @exit_station = exit_station
  end
end
