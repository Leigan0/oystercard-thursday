require 'oystercard'

describe Oystercard do
  let(:journey) {double :journey, origin: entry_station, destination: exit_station }
  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }
  let(:journey_class) { double :journey_class, new: journey}
  subject(:oystercard) { described_class.new(journey_class) }

  describe 'initially' do
    it 'has a initial balance of 0' do
      expect(oystercard.balance).to eq 0
    end

    it 'is not in a journey' do
      expect(oystercard.in_journey?).to be false
    end

    it 'has no history' do
      expect(oystercard.history).to be_empty
    end
  end

  describe '#top_up' do
    it 'checks if the card has been topped-up' do
      expect { oystercard.top_up 1 }.to change { oystercard.balance }.by 1
    end

    it 'fails to top up beyond £90' do
      fail_message = "cannot top-up, #{oystercard.balance + 100} is greater than limit of #{Oystercard::MAXIMUM_BALANCE}"
      expect { oystercard.top_up 100 }.to raise_error fail_message
    end
  end

  describe '#touch_in' do
    it 'touches in successfully' do
      oystercard.top_up(2)
      expect(journey_class).to receive(:new)
      oystercard.touch_in(entry_station)
    end

    it 'passes entry station to journey' do
      oystercard.top_up(2)
      expect(journey).to receive(:origin)
      oystercard.touch_in(entry_station)
    end

    context 'when balance is below £1' do
      it 'refuses to touch in' do
        expect{ oystercard.touch_in(entry_station) }.to raise_error 'Not enough money on your card'
      end
    end
  end

  describe '#touch_out' do
    before(:each) do
      oystercard.top_up(2)
      oystercard.touch_in(entry_station)
    end

    it 'passes exit station to journey' do
      expect(journey).to receive(:destination)
      oystercard.touch_out(exit_station)
    end

    it 'deducts the fare from my balance' do
      expect { oystercard.touch_out(exit_station) }.to change { oystercard.balance }.by -1
    end

    it 'stores the journey when touching out' do
      oystercard.touch_out(exit_station)
      expect(oystercard.history).to include (journey)
    end
    it 'sets current_journey to nil' do
      oystercard.touch_out(exit_station)
      expect(oystercard).not_to be_in_journey
    end
  end
end
