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

    describe '.teams' do
      let(:year) { 2015 }
      let(:url) { "http://ergast.com/api/f1/#{year}/constructorstandings.json" }

      # Contains just 2 teams for simplicity
      let(:teams_fixture) { "#{fixtures_path}/teams.json" }

      before do
        stub_request(:get, url)
            .to_return(status: 200, body: IO.read(teams_fixture))
      end

      it 'returns the teams of the given season' do
        expect(subject.teams(year).map(&:to_json))
            .to eq [Team.new('Mercedes', 'German', 703),
                    Team.new('Ferrari', 'Italian', 428)].map(&:to_json)
      end
    end
  end
end
