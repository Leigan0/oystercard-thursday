require 'journeylog'

describe Journeylog do
  let(:journey) {double :journey, origin: entry_station, destination: exit_station}
  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }
  let(:journey_class) { double :journey_class, new: journey}
  subject(:journeylog) { described_class.new(journey_class) }

  describe '#journeys' do
    it 'returns an immutable copy of the journey log' do
      subject.start(entry_station)
      subject.finish(exit_station)
      expect(subject.journeys).to eq [journey]
    end
  end

  describe '#start' do
    it 'touches in successfully' do
      expect(journey_class).to receive(:new)
      subject.start(entry_station)
    end
    it 'passes entry station to journey' do
      expect(journey).to receive(:origin)
      subject.start(entry_station)
    end
    it 'stores current journey to history' do
        subject.start(entry_station)
        expect(subject.journeys).to eq [journey]
    end
  end

  describe '#finish' do
    it 'should not create a new journey if journey started' do
      subject.start(entry_station)
      expect(journey_class).not_to receive(:new)
      subject.finish(exit_station)
    end
    it 'passes exit station to journey' do
      expect(journey).to receive(:destination)
      subject.finish(exit_station)
    end
    it 'sets current_journey to nil' do
      subject.finish(exit_station)
      expect(subject.journey).to be_falsey
    end
    context 'incomplete journey' do
      it 'should create a new journey if journey not already started' do
        expect(journey_class).to receive(:new)
        subject.finish(exit_station)
      end
    end
  end
end
