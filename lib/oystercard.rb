class Oystercard
  #controls the user balance
  require_relative 'journey'

  MINIMUM_FARE = 1
  MAXIMUM_BALANCE = 90

  attr_reader :balance
  attr_reader :history

  def initialize(journey_class = Journey)
    @balance = 0
    @history = []
    @journey_class = journey_class
  end

  def top_up(amount)
    fail_message = "cannot top-up, #{@balance + amount} is greater than limit of #{MAXIMUM_BALANCE}"
    raise fail_message if limit_exceeded?(amount)
    @balance += amount
  end

  def touch_in(entry_station)
    raise 'Not enough money on your card' if insufficient_funds?
    @current_journey = @journey_class.new
    @current_journey.origin(entry_station)
  end

  def touch_out(exit_station)
    deduct(@current_journey.fare)
    @current_journey.destination(exit_station)
    complete_journey
  end

  def in_journey?
    !@current_journey.nil?
  end

  private

  def limit_exceeded?(amount)
    @balance + amount > MAXIMUM_BALANCE
  end

  def deduct(amount)
    @balance -= amount
  end

  def insufficient_funds?
    @balance < MINIMUM_FARE
  end

  private

  def complete_journey
      @history << @current_journey
      @current_journey = nil
  end

end
