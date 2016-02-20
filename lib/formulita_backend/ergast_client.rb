require 'net/http'
require 'json'

module FormulitaBackend
  class ErgastClient

    BASE_PATH = 'http://ergast.com/api/f1/'.freeze
    private_constant :BASE_PATH

    class << self

      def races(year)
        response = get(races_path(year))
        parsed_response = parse(response)
        races_info(parsed_response).map do |race_info|
          year = race_info['season'].to_i
          round = race_info['round'].to_i
          country = race_info['Circuit']['Location']['country']
          end_date = race_info['date']
          Race.new(year, round, country, end_date)
        end
      end

      # Drivers are returned in order according to their position in the
      # championship.
      def drivers(year)
        response = get(drivers_path(year))
        parsed_response = parse(response)
        driver_standings(parsed_response).map do |driver_info|
          first_name = driver_info['Driver']['givenName']
          last_name = driver_info['Driver']['familyName']
          nationality = driver_info['Driver']['nationality']
          team = driver_info['Constructors'].first['name'] # What if size > 1 ?
          points = driver_info['points'].to_i
          Driver.new(first_name, last_name, nationality, team, points)
        end
      end

      def teams(year)
        response = get(teams_path(year))
        parsed_response = parse(response)
        team_standings(parsed_response).map do |team_info|
          name = team_info['Constructor']['name']
          nationality = team_info['Constructor']['nationality']
          points = team_info['points'].to_i
          Team.new(name, nationality, points)
        end
      end

      def qualifying_results(year, round)
        response = get(qualifying_results_path(year, round))
        parsed_response = parse(response)
        qualifying_info(parsed_response).map do |position_info|
          position = position_info['position'].to_i
          driver_code = position_info['Driver']['code']
          q1 = position_info['Q1']
          q2 = position_info['Q2']
          q3 = position_info['Q3']
          QualifyingResult.new(position, driver_code, q1, q2, q3)
        end
      end

      def race_results(year, round)
        response = get(race_results_path(year, round))
        parsed_response = parse(response)
        results_info(parsed_response).map do |position_info|
          position = position_info['position'].to_i
          driver_code = position_info['Driver']['code']
          laps = position_info['laps'].to_i
          status = position_info['status']
          time = (status == 'Finished' ? position_info['Time']['time'] : nil)
          grid = position_info['grid'].to_i
          race_points = position_info['points'].to_i
          RaceResult.new(position, driver_code, laps, time, status, grid, race_points)
        end
      end

      private

      def get(path)
        Net::HTTP.get(URI(path))
      end

      def parse(response)
        JSON.parse(response)
      end

      def races_path(year)
        "#{BASE_PATH}#{year}/races.json".freeze
      end

      def races_info(races_parsed_resp)
        races_parsed_resp['MRData']['RaceTable']['Races']
      end

      def drivers_path(year)
        "#{BASE_PATH}#{year}/driverstandings.json".freeze
      end

      def driver_standings(drivers_parsed_resp)
        drivers_parsed_resp['MRData']['StandingsTable']['StandingsLists']
            .first['DriverStandings']
      end

      def teams_path(year)
        "#{BASE_PATH}#{year}/constructorstandings.json".freeze
      end

      def team_standings(teams_parsed_resp)
        teams_parsed_resp['MRData']['StandingsTable']['StandingsLists']
            .first['ConstructorStandings']
      end

      def qualifying_info(qualy_parsed_resp)
        qualy_parsed_resp['MRData']['RaceTable']['Races']
            .first['QualifyingResults']
      end

      def qualifying_results_path(year, round)
        "#{BASE_PATH}#{year}/#{round}/qualifying.json"
      end

      def results_info(results_parsed_resp)
        results_parsed_resp['MRData']['RaceTable']['Races']
            .first['Results']
      end

      def race_results_path(year, round)
        "#{BASE_PATH}#{year}/#{round}/results.json"
      end

    end

  end
end
