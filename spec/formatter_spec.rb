require 'spec_helper'

module FormulitaBackend
  # Using a Championship with only a few races and drivers to simplify.
  describe Formatter do
    subject { described_class }

    describe '.formatted_championship' do
      let(:year) { 2014 }

      let(:races) { [Race.new(2014, 1, 'Australia', '2014-03-16', '06:00:00Z')] }

      let(:drivers) do
        [Driver.new('HAM', 'British', 'Mercedes', 317),
         Driver.new('ROS', 'German', 'Mercedes', 238)]
      end

      let(:teams) do
        [Team.new('Mercedes', 'German', 405),
         Team.new('Red Bull', 'Austrian', 320)]
      end

      let(:qualy_results) do
        [[QualifyingResult.new(1, 'HAM', '1:31.699', '1:42.890', '1:44.231')]]
      end

      let(:race_results) { [[RaceResult.new(1, 'ROS', 57, '1:32:58.710', 3, 25)]] }

      let(:championship) do
        Championship.new(year, races, drivers, teams, qualy_results, race_results)
      end

      it 'returns a championship with the format expected by the Android app' do
        expected_result =
            { year: 2014,
              races: [
                  { year: 2014, number: 1, country: 'Australia',
                    startDate: '2014-03-14T06:00:00Z', endDate: '2014-03-16T06:00:00Z',
                    winner: 'N.Rosberg',
                    qualyResults: [{ position: 1, driver: 'L.Hamilton', team: 'Mercedes',
                                     q1: '1:31.699', q2: '1:42.890', q3: '1:44.231' }],
                    raceResults: [{ position: 1, driver: 'N.Rosberg', team: 'Mercedes',
                                    laps: 57, time: '1:32:58.710', grid: 3, points: 25 }] }
              ],
              drivers: [
                  { name: 'L.Hamilton', country: 'G.Britain', team: 'Mercedes',
                    points: 317, year: 2014, position: 1 },
                  { name: 'N.Rosberg', country: 'Germany', team: 'Mercedes',
                    points: 238, year: 2014, position: 2 }
              ],
              teams: [
                  { name: 'Mercedes', country: 'Germany', points: 405, year: 2014, position: 1 },
                  { name: 'Red Bull', country: 'Austria', points: 320, year: 2014, position: 2 }
              ]
            }.to_json

        expect(subject.formatted_championship(championship)).to eq expected_result
      end
    end
  end
end
