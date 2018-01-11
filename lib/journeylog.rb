class Journeylog
  attr_reader :journey, :history
require_relative 'journey'
  def initialize(journey_class = Journey)
    @journey_class = journey_class
    @history = []
  end

  def start(entry_station)
    @history << current_journey
    current_journey.origin(entry_station)
  end

  def finish(exit_station)
    current_journey
    current_journey.destination(exit_station)
    @journey = nil
  end

  private

  def current_journey
    @journey ||= @journey_class.new
  end

end
