require_relative 'journey'
class Journeylog
  attr_reader :journey
  def initialize(journey_class = Journey)
    @journey_class = journey_class
    @log = []
  end

  def start(entry_station)
    current_journey.origin(entry_station)
    update_log
  end

  def finish(exit_station)
    current_journey.destination(exit_station)
    update_log
    @journey = nil
  end

  def journeys
    @log.dup
  end

  private

  def current_journey
    @journey ||= @journey_class.new
  end

  def update_log
    unless @log.include?(current_journey) then @log << current_journey end
  end

end
