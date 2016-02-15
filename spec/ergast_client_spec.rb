require 'spec_helper'

module FormulitaBackend
  describe ErgastClient do
    subject { ErgastClient }

    describe '.drivers' do
      let(:year) { 2015 }
      let(:url) { "http://ergast.com/api/f1/#{year}/driverstandings.json" }

      # Contains just 2 drivers for simplicity
      let(:drivers_fixture) { "#{fixtures_path}/drivers.json" }

      before do
        stub_request(:get, url)
            .to_return(status: 200, body: IO.read(drivers_fixture))
      end

      it 'returns the drivers of the given season' do
        expect(subject.drivers(year).map(&:to_json))
            .to eq [Driver.new('Lewis', 'Hamilton', 'British', 'Mercedes', 381),
                    Driver.new('Nico', 'Rosberg', 'German', 'Mercedes', 322)].map(&:to_json)
      end
    end
  end
end
