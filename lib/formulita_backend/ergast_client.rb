require 'net/http'

module FormulitaBackend
  class ErgastClient

    BASE_PATH = 'http://ergast.com/api/f1/'.freeze
    private_constant :BASE_PATH

    class << self

      def races(year)
        response = get(races_path(year))
        parsed_response = json_response(response)
        parsed_races(parsed_response)
      end

      # Drivers are returned in order according to their position in the
      # championship.
      def drivers(year)
        response = get(drivers_path(year))
        parsed_response = json_response(response)
        parsed_driver_standings(parsed_response)
      end

      def teams(year)
        response = get(teams_path(year))
        parsed_response = json_response(response)
        parsed_team_standings(parsed_response)
      end

      def qualifying_results(year, round)
        response = get(qualifying_results_path(year, round))
        parsed_response = json_response(response)
        parsed_qualifying_info(parsed_response)
      end

      def race_results(year, round)
        response = get(race_results_path(year, round))
        parsed_response = json_response(response)
        parsed_results_info(parsed_response)
      end

      private

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
          year = race_info['season'].to_i
          round = race_info['round'].to_i
          country = race_info['Circuit']['Location']['country']
          end_date = race_info['date']
          Race.new(year, round, country, end_date)
        end
      end

      def drivers_path(year)
        "#{BASE_PATH}#{year}/driverstandings.json".freeze
      end

      def parsed_driver_standings(drivers_resp_json)
        drivers_resp_json['MRData']['StandingsTable']['StandingsLists']
            .first['DriverStandings'].map do |driver_info|
          first_name = driver_info['Driver']['givenName']
          last_name = driver_info['Driver']['familyName']
          nationality = driver_info['Driver']['nationality']
          team = driver_info['Constructors'].first['name'] # What if size > 1 ?
          points = driver_info['points'].to_i
          Driver.new(first_name, last_name, nationality, team, points)
        end
      end

      def teams_path(year)
        "#{BASE_PATH}#{year}/constructorstandings.json".freeze
      end

      def parsed_team_standings(teams_resp_json)
        teams_resp_json['MRData']['StandingsTable']['StandingsLists']
            .first['ConstructorStandings'].map do |team_info|
          name = team_info['Constructor']['name']
          nationality = team_info['Constructor']['nationality']
          points = team_info['points'].to_i
          Team.new(name, nationality, points)
        end
      end

      def qualifying_results_path(year, round)
        "#{BASE_PATH}#{year}/#{round}/qualifying.json".freeze
      end

      def parsed_qualifying_info(qualy_resp_json)
        qualy_resp_json['MRData']['RaceTable']['Races']
            .first['QualifyingResults'].map do |position_info|
          position = position_info['position'].to_i
          driver_code = position_info['Driver']['code']
          q1 = position_info['Q1']
          q2 = position_info['Q2'] || ''
          q3 = position_info['Q3'] || ''
          QualifyingResult.new(position, driver_code, q1, q2, q3)
        end
      end

      def race_results_path(year, round)
        "#{BASE_PATH}#{year}/#{round}/results.json".freeze
      end

      def parsed_results_info(results_resp_json)
        results_resp_json['MRData']['RaceTable']['Races']
            .first['Results'].map do |position_info|
          position = position_info['position'].to_i
          driver_code = position_info['Driver']['code']
          laps = position_info['laps'].to_i
          status = position_info['status']

          # There is one race that does not have Time data. 14th of 2015.
          # That is why I cannot check position_info['Time']['time'] even
          # when status = finished.
          time = (position_info['Time'] ? position_info['Time']['time'] : nil)

          grid = position_info['grid'].to_i
          race_points = position_info['points'].to_i
          RaceResult.new(position, driver_code, laps, time, status, grid, race_points)
        end
      end

    end

  end
end
