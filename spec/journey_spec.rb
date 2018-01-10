require 'journey'

describe Journey do
  subject(:journey) { described_class.new }
  let (:entry_station) { double :entry_station }
  let (:exit_station) { double :exit_station }

  it 'stores the entry station' do
    journey.origin(entry_station)
    expect(journey.entry_station).to eq entry_station
  end
  describe '#complete' do
    it 'stores the exit station' do
      journey.destination(exit_station)
      expect(journey.exit_station).to eq exit_station
    end
  end
  describe '#complete?' do
      it 'confirms journey complete when journey given a touch in and touch out station' do
        journey.origin(entry_station)
        journey.destination(exit_station)
        expect(journey).to be_complete
    end
    it 'confirms journey incomplete when only entry station provided' do
      journey.origin(entry_station)
      expect(journey).not_to be_complete
    end
  end
  describe '#fare' do
    it 'returns the minimum fare' do
      journey.origin(entry_station)
      journey.destination(exit_station)
      expect(journey.fare).to eq Journey::MINIMUM_FARE
    end
    context 'when only one station in journey' do
      it 'returns the penalty fare' do
        journey.origin(entry_station)
        expect(journey.fare).to eq Journey::PENALTY_FARE
      end
    end
  end
end
