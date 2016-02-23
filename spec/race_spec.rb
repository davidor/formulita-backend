require 'spec_helper'

module FormulitaBackend
  describe Race do
    describe '#start_date' do
      context 'when the race is in Monaco' do
        let(:race) { Race.new(2015, 6, 'Monaco', '2015-05-24') }

        it 'returns 3 days before the day of the race' do
          expect(race.start_date).to eq '2015-05-21'
        end
      end

      context 'when the race is not in Monaco' do
        let(:race) { Race.new(2015, 1, 'Australia', '2015-03-15') }

        it 'returns 2 days before the day of the race' do
          expect(race.start_date).to eq '2015-03-13'
        end
      end
    end
  end
end
