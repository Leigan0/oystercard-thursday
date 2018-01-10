require 'journey'

describe Journey do
  subject(:journey) { described_class.new }
  let (:entry_station) { double :entry_station }
  let (:exit_station) { double :exit_station }

  it 'stores the entry station' do
    journey.start(entry_station)
    expect(subject.entry_station).to eq entry_station
  end
  describe '#complete' do
    it 'stores the exit station' do
      journey.complete(exit_station)
      expect(journey.exit_station).to eq exit_station
    end
  end
  describe '#complete?' do
      it 'confirms journey complete when journey given a touch in and touch out station' do
        journey.start(entry_station)
        journey.complete(exit_station)
        expect(journey).to be_complete
    end
    it 'confirms journey incomplete when only entry station provided' do
      subject.start(entry_station)
      expect(journey).not_to be_complete
    end
  end
end
