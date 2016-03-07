require 'net/http'

module FormulitaBackend
  class ErgastClient

    BASE_PATH = 'http://ergast.com/api/f1/'.freeze
    private_constant :BASE_PATH

    class << self

      def races(year)
        get_resource(:races, year)
      end

      # Drivers are returned in order according to their position in the
      # championship.
      def drivers(year)
        get_resource(:drivers, year)
      end

      def teams(year)
        get_resource(:teams, year)
      end

      def qualifying_results(year, round)
        get_resource(:qualifying_results, year, round)
      end

      def race_results(year, round)
        get_resource(:race_results, year, round)
      end

      private

      def get_resource(resource, year, round = nil)
        response = if round
                     get(send("#{resource}_path".to_sym, year, round))
                   else
                     get(send("#{resource}_path".to_sym, year))
                   end
        parsed_response = json_response(response)
        send("parsed_#{resource}", parsed_response)
      end

      def get(path)
        Net::HTTP.get(URI(path))
      end

      def json_response(response)
        JSON.parse(response)
      end

      def races_path(year)
        "#{BASE_PATH}#{year}/races.json".freeze
      end

      def parsed_races(races_resp_json)
        races_resp_json['MRData']['RaceTable']['Races'].map do |race_info|
          { year: race_info['season'].to_i,
            round: race_info['round'].to_i,
            country: race_info['Circuit']['Location']['country'],
            date: race_info['date'],
            time: race_info['time'] }
        end
      end

      def drivers_path(year)
        "#{BASE_PATH}#{year}/driverstandings.json".freeze
      end

      def parsed_drivers(drivers_resp_json)
        drivers_resp_json['MRData']['StandingsTable']['StandingsLists']
            .first['DriverStandings'].map do |driver_info|
          { code: driver_info['Driver']['code'],
            nationality: driver_info['Driver']['nationality'],
            team: driver_info['Constructors'].first['name'], # What if size > 1
            points: driver_info['points'].to_i }
        end
      end

      def teams_path(year)
        "#{BASE_PATH}#{year}/constructorstandings.json".freeze
      end

      def parsed_teams(teams_resp_json)
        teams_resp_json['MRData']['StandingsTable']['StandingsLists']
            .first['ConstructorStandings'].map do |team_info|
          { name: team_info['Constructor']['name'],
            nationality: team_info['Constructor']['nationality'],
            points: team_info['points'].to_i }
        end
      end

      def qualifying_results_path(year, round)
        "#{BASE_PATH}#{year}/#{round}/qualifying.json".freeze
      end

      def parsed_qualifying_results(qualy_resp_json)
        qualy_resp_json['MRData']['RaceTable']['Races']
            .first['QualifyingResults'].map do |position_info|
          { position: position_info['position'].to_i,
            driver_code: position_info['Driver']['code'],
            q1: position_info['Q1'],
            q2: position_info['Q2'] || '',
            q3: position_info['Q3'] || '' }
        end
      end

      def race_results_path(year, round)
        "#{BASE_PATH}#{year}/#{round}/results.json".freeze
      end

      def parsed_race_results(results_resp_json)
        results_resp_json['MRData']['RaceTable']['Races']
            .first['Results'].map do |position_info|
          { position: position_info['position'].to_i,
            driver_code: position_info['Driver']['code'],
            laps: position_info['laps'].to_i,
            time: if position_info['Time']
                    position_info['Time']['time']
                  else
                    position_info['status']
                  end,
            grid: position_info['grid'].to_i,
            points: position_info['points'].to_i }
        end
      end

    end

  end
end
