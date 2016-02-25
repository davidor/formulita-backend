require 'spec_helper'

module FormulitaBackend
  describe ErgastClient do

    # All the fixtures used in these tests have been simplified.
    # For example, there are 19 races in the 2015 championship, but in order to
    # simplify the tests, I use a fixture with only 2.

    subject { ErgastClient }

    let(:year) { 2015 }
    let(:round) { 1 }

    # Objects that appear in the fixtures
    let(:races) do
      { australia: Race.new(2015, 1, 'Australia', '2015-03-15'),
        malaysia: Race.new(2015, 2, 'Malaysia', '2015-03-29') }
    end

    let(:drivers) do
      { hamilton: Driver.new('HAM', 'British', 'Mercedes', 381),
        rosberg: Driver.new('ROS', 'German', 'Mercedes', 322) }
    end

    let(:teams) do
      { mercedes: Team.new('Mercedes', 'German', 703),
        ferrari: Team.new('Ferrari', 'Italian', 428) }
    end

    let(:qualy_results) do
      { hamilton_australia:
            QualifyingResult.new(1, 'HAM', '1:28.586', '1:26.894', '1:26.327'),
        rosberg_australia:
            QualifyingResult.new(2, 'ROS', '1:28.906', '1:27.097', '1:26.921') }
    end

    let(:race_results) do
      { hamilton_australia:
            RaceResult.new(1, 'HAM', 58, '1:31:54.067', 1, 25),
        rosberg_australia:
            RaceResult.new(2, 'ROS', 58, '+1.360', 2, 18) }
    end

    describe '.races' do
      let(:url) { "http://ergast.com/api/f1/#{year}/races.json" }
      let(:races_fixture) { "#{fixtures_path}/races.json" }

      before do
        stub_request(:get, url)
            .to_return(status: 200, body: IO.read(races_fixture))
      end

      it 'returns the races of the given season' do
        expect(subject.races(year).map(&:to_h))
            .to eq [races[:australia], races[:malaysia]].map(&:to_h)
      end
    end

    describe '.drivers' do
      let(:url) { "http://ergast.com/api/f1/#{year}/driverstandings.json" }
      let(:drivers_fixture) { "#{fixtures_path}/drivers.json" }

      before do
        stub_request(:get, url)
            .to_return(status: 200, body: IO.read(drivers_fixture))
      end

      it 'returns the drivers of the given season' do
        expect(subject.drivers(year).map(&:to_h))
            .to eq [drivers[:hamilton], drivers[:rosberg]].map(&:to_h)
      end
    end

    describe '.teams' do
      let(:url) { "http://ergast.com/api/f1/#{year}/constructorstandings.json" }
      let(:teams_fixture) { "#{fixtures_path}/teams.json" }

      before do
        stub_request(:get, url)
            .to_return(status: 200, body: IO.read(teams_fixture))
      end

      it 'returns the teams of the given season' do
        expect(subject.teams(year).map(&:to_h))
            .to eq [teams[:mercedes], teams[:ferrari]].map(&:to_h)
      end
    end

    describe '.qualifying_results' do
      let(:url) { "http://ergast.com/api/f1/#{year}/#{round}/qualifying.json" }
      let(:qualy_results_fixture) { "#{fixtures_path}/qualy_results.json" }

      before do
        stub_request(:get, url)
            .to_return(status: 200, body: IO.read(qualy_results_fixture))
      end

      it 'returns the qualifying results of the given race' do
        expect(subject.qualifying_results(year, round).map(&:to_h))
            .to eq [qualy_results[:hamilton_australia],
                    qualy_results[:rosberg_australia]].map(&:to_h)
      end
    end

    describe '.race_results' do
      let(:url) { "http://ergast.com/api/f1/#{year}/#{round}/results.json" }
      let(:race_results_fixture) { "#{fixtures_path}/race_results.json" }

      before do
        stub_request(:get, url)
            .to_return(status: 200, body: IO.read(race_results_fixture))
      end

      it 'returns the results of the given race' do
        expect(subject.race_results(year, round).map(&:to_h))
            .to eq [race_results[:hamilton_australia],
                    race_results[:rosberg_australia]].map(&:to_h)
      end
    end
  end
end
