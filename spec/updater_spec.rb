require 'spec_helper'

module FormulitaBackend
  describe Updater do
    describe '.update' do
      let(:year) { 2015 }
      let(:data_path) { Updater.const_get(:DATA_PATH) }
      let(:ergast_client) do
        double(championship: { races: [],  drivers: [], teams: [] })
      end

      subject { Updater.new(ergast_client: ergast_client) }

      it 'writes to a JSON file' do
        expect(File).to receive(:open)
                    .with("#{data_path}/#{year}.json", 'w')
        subject.update(year)
      end
    end
  end
end
