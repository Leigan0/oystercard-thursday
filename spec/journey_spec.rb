require 'journey'

describe Journey do
  subject(:journey) { described_class.new }
  let (:entry_station) { double :entry_station }

  it 'stores the entry station' do
    journey.start(entry_station)
    expect(subject.entry_station).to eq entry_station
  end
end
