require 'spec_helper'

module FormulitaBackend
  describe ErgastClient do

    # All the fixtures used in these tests have been simplified.
    # For example, there are 19 races in the 2015 championship, but in order to
    # simplify the tests, I use a fixture with only 2.

    subject { ErgastClient }

    let(:year) { 2015 }
    let(:round) { 1 }

    let(:requests) do
      [{ url: "http://ergast.com/api/f1/#{year}/races.json",
         fixtures: "#{fixtures_path}/races.json" },
       { url: "http://ergast.com/api/f1/#{year}/driverstandings.json",
         fixtures: "#{fixtures_path}/drivers.json" },
       { url: "http://ergast.com/api/f1/#{year}/constructorstandings.json",
         fixtures: "#{fixtures_path}/teams.json" },
       { url: "http://ergast.com/api/f1/#{year}/#{round}/qualifying.json",
         fixtures: "#{fixtures_path}/qualy_results.json" },
       { url: "http://ergast.com/api/f1/#{year}/#{round}/results.json",
         fixtures: "#{fixtures_path}/race_results.json" }]
    end

    # Stub the requests
    before do
      requests.each do |request|
        stub_request(:get, request[:url])
            .to_return(status: 200, body: IO.read(request[:fixtures]))
      end
    end

    # Entities that appear in the fixtures
    let(:races) do
      [{ year: year,
         round: 1,
         country: 'Australia',
         date: '2015-03-15',
         time: '05:00:00Z' }]
    end

    let(:drivers) do
      [{ code: 'HAM', nationality: 'British', team: 'Mercedes', points: 381 },
       { code: 'ROS', nationality: 'German', team: 'Mercedes', points: 322 }]
    end

    let(:teams) do
      [{ name: 'Mercedes', nationality: 'German', points: 703 },
       { name: 'Ferrari', nationality: 'Italian', points: 428 }]
    end

    let(:qualy_results) do
      [{ position: 1, driver_code: 'HAM', team: 'Mercedes',
         q1: '1:28.586', q2: '1:26.894', q3: '1:26.327' },
       { position: 2, driver_code: 'ROS', team: 'Mercedes',
         q1: '1:28.906', q2: '1:27.097', q3: '1:26.921' }]
    end

    let(:race_results) do
      [{ position: 1, driver_code: 'HAM', team: 'Mercedes',
         laps: 58, time: '1:31:54.067', grid: 1, points: 25 },
       { position: 2, driver_code: 'ROS', team: 'Mercedes',
         laps: 58, time: '+1.360', grid: 2, points: 18 }]
    end

    let(:championship) do
      { year: year,
        races: races,
        drivers: drivers,
        teams: teams,
        qualy_results: [qualy_results],
        race_results: [race_results] }
    end

    describe '.championship' do
      it 'returns the championship of the given season' do
        expect(subject.championship(year)).to eq championship
      end
    end
  end
end
