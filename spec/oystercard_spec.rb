require 'oystercard'

describe Oystercard do
  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }
  let(:journey) {double :journey, origin: entry_station, destination: exit_station, fare: 1, complete?: true }
  let(:journeylog) { double :journeylog, journeys:[journey], start: true, finish: nil}
  let(:journey_class) { double :journey_class, new: journeylog}
  subject(:oystercard) { described_class.new(journey_class) }

  describe 'initialize' do
    it 'has a initial balance of 0' do
      expect(oystercard.balance).to eq 0
    end
    it 'is not in a journey' do
      expect(oystercard).not_to be_in_journey
    end
  end

  describe '#top_up' do
    it 'checks if the card has been topped-up' do
      expect { oystercard.top_up Oystercard::MINIMUM_FARE }.to change { oystercard.balance }.by Oystercard::MINIMUM_FARE
    end

    it 'fails to top up beyond MAXIMUM_BALANCE' do
      top_up_amount = Oystercard::MAXIMUM_BALANCE+1
      fail_message = "cannot top-up, #{oystercard.balance + top_up_amount } is greater than limit of #{Oystercard::MAXIMUM_BALANCE}"
      expect { oystercard.top_up top_up_amount }.to raise_error fail_message
    end

  end

  describe '#touch_in' do
    context 'when balance is below MINIMUM_FARE' do
      it 'refuses to touch in' do
        expect{ oystercard.touch_in(entry_station) }.to raise_error 'Not enough money on your card'
      end
    end
    context 'card topped up' do
      before(:each) do
        oystercard.top_up(10)
        oystercard.touch_in(entry_station)
      end
      it 'passes journey entry station to journeylog ' do
        expect(journeylog).to receive(:start).with(entry_station)
        oystercard.touch_in(entry_station)
      end
      it 'confirms card in_journey' do
        expect(oystercard).to be_in_journey
      end
      context 'when previous journey was not complete' do
        it 'confirms if previous journey within journey log complete' do
          expect(journey).to receive(:complete?)
          oystercard.touch_in(entry_station)
        end
        it 'confirms confirms fare of previous journey to deduct if not complete' do
          allow(journey).to receive(:complete?).and_return(false)
          expect(journey).to receive(:fare)
          oystercard.touch_in(entry_station)
        end
      end
    end
  end

  describe '#touch_out' do
    it 'passes exit station to journey' do
      expect(journeylog).to receive(:finish).with(exit_station)
      oystercard.touch_out(exit_station)
    end
    it 'deducts the returned fare from my balance' do
      expect { oystercard.touch_out(exit_station) }.to change { oystercard.balance }.by -1
    end
    it 'sets in_journey to false' do
      oystercard.touch_out(exit_station)
      expect(oystercard).not_to be_in_journey
    end
    it 'receives fare method from journey' do
      expect(journey).to receive(:fare)
      oystercard.touch_out(exit_station)
    end
  end
end
