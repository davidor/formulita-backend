require 'spec_helper'

module FormulitaBackend
  describe ErgastClient do

    # All the fixtures used in these tests have been simplified.
    # For example, there are 19 races in the 2015 championship, but in order to
    # simplify the tests, I use a fixture with only 2.

    subject { ErgastClient }

    let(:year) { 2015 }
    let(:round) { 1 }

    # Entities that appear in the fixtures
    let(:races) do
      { australia: { year: year,
                     round: 1,
                     country: 'Australia',
                     date: '2015-03-15',
                     time: '05:00:00Z' },
        malaysia: { year: year,
                    round: 2,
                    country: 'Malaysia',
                    date: '2015-03-29',
                    time: '07:00:00Z' } }
    end

    let(:drivers) do
      { hamilton: { code: 'HAM',
                    nationality: 'British',
                    team: 'Mercedes',
                    points: 381 },
        rosberg: { code: 'ROS',
                   nationality: 'German',
                   team: 'Mercedes',
                   points: 322 } }
    end

    let(:teams) do
      { mercedes: { name: 'Mercedes', nationality: 'German', points: 703 },
        ferrari: { name: 'Ferrari', nationality: 'Italian', points: 428 } }
    end

    let(:qualy_results) do
      { hamilton_australia:
            { position: 1, driver_code: 'HAM', team: 'Mercedes',
              q1: '1:28.586', q2: '1:26.894', q3: '1:26.327' },
        rosberg_australia:
            { position: 2, driver_code: 'ROS', team: 'Mercedes',
              q1: '1:28.906', q2: '1:27.097', q3: '1:26.921' } }
    end

    let(:race_results) do
      { hamilton_australia:
            { position: 1, driver_code: 'HAM', team: 'Mercedes',
              laps: 58, time: '1:31:54.067', grid: 1, points: 25 },
        rosberg_australia:
            { position: 2, driver_code: 'ROS', team: 'Mercedes',
              laps: 58, time: '+1.360', grid: 2, points: 18 } }
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
            .to eq [races[:australia], races[:malaysia]]
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
            .to eq [drivers[:hamilton], drivers[:rosberg]]
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
            .to eq [teams[:mercedes], teams[:ferrari]]
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
                    qualy_results[:rosberg_australia]]
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
                    race_results[:rosberg_australia]]
      end
    end
  end
end
