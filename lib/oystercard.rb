class Oystercard
  require_relative 'journeylog'

  MINIMUM_FARE = 1
  MAXIMUM_BALANCE = 90

  attr_reader :balance, :journeylog

  def initialize(journey_log_class = Journeylog)
    @balance = 0
    @journeylog = journey_log_class.new
    @in_journey = false
  end

  def top_up(amount)
    raise "cannot top-up, #{balance + amount} is greater than limit of #{MAXIMUM_BALANCE}" if limit_exceeded?(amount)
    @balance += amount
  end

  def touch_in(entry_station)
    raise 'Not enough money on your card' if insufficient_funds?
    outstanding_penalty_charges if in_journey?
    journeylog.start(entry_station)
    @in_journey = true
  end

  def touch_out(exit_station)
    journeylog.finish(exit_station)
    deduct(journeylog.journeys[-1].fare)
    @in_journey = false
  end

  def in_journey?
    @in_journey
  end

  private

  def limit_exceeded?(amount)
    balance + amount > MAXIMUM_BALANCE
  end

  def deduct(amount)
    @balance -= amount
  end

  def insufficient_funds?
    balance < MINIMUM_FARE
  end

  def outstanding_penalty_charges
    journeylog.journeys[-1].complete? ? deduct(0) : deduct(journeylog.journeys[-1].fare)
  end
end
