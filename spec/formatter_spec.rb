require 'spec_helper'

module FormulitaBackend
  # Using a Championship with only a few races and drivers to simplify.
  describe Formatter do
    subject { described_class }

    describe '.formatted_championship' do
      let(:year) { 2014 }

      let(:races) do
        [{ year: year,
           round: 1,
           country: 'Australia',
           date: '2014-03-16',
           time: '06:00:00Z' }]
      end

      let(:drivers) do
        [{ code: 'HAM', nationality: 'British', team: 'Mercedes', points: 317 },
         { code: 'ROS', nationality: 'German', team: 'Mercedes', points: 238 }]
      end

      let(:teams) do
        [{ name: 'Mercedes', nationality: 'German', points: 405 },
         { name: 'Red Bull', nationality: 'Austrian', points: 320 }]
      end

      let(:qualy_results) do
        [[{ position: 1, driver_code: 'HAM',
            q1: '1:31.699', q2: '1:42.890', q3: '1:44.231' }]]
      end

      let(:race_results) do
        [[{ position: 1,
            driver_code: 'ROS',
            laps: 57,
            time: '1:32:58.710',
            grid: 3,
            points: 25 }]]
      end

      let(:championship) do
        { year: year, races: races, drivers: drivers, teams: teams,
          qualy_results: qualy_results, race_results: race_results }
      end

      it 'returns a championship with the format expected by the Android app' do
        formatted_year = 2014
        formatted_races =
            [{ year: 2014,
               number: 1,
               country: 'Australia',
               startDate: '2014-03-14T06:00:00Z',
               endDate: '2014-03-16T06:00:00Z',
               winner: 'N.Rosberg',
               qualyResults: [{ position: 1, driver: 'L.Hamilton', team: 'Mercedes',
                                q1: '1:31.699', q2: '1:42.890', q3: '1:44.231' }],
               raceResults: [{ position: 1, driver: 'N.Rosberg', team: 'Mercedes',
                               laps: 57, time: '1:32:58.710', grid: 3, points: 25 }] }]
        formatted_drivers =
            [{ name: 'L.Hamilton', country: 'G.Britain', team: 'Mercedes',
               points: 317, year: 2014, position: 1 },
             { name: 'N.Rosberg', country: 'Germany', team: 'Mercedes',
               points: 238, year: 2014, position: 2 }]
        formatted_teams =
            [{ name: 'Mercedes', country: 'Germany',
               points: 405, year: 2014, position: 1 },
             { name: 'Red Bull', country: 'Austria',
               points: 320, year: 2014, position: 2 }]

        expect(subject.formatted_championship(championship))
            .to eq ({ year: formatted_year,
                      races: formatted_races,
                      drivers: formatted_drivers,
                      teams: formatted_teams })
      end
    end
  end
end
