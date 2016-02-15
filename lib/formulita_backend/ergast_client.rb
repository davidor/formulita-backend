require 'net/http'
require 'json'

module FormulitaBackend
  class ErgastClient

    BASE_PATH = 'http://ergast.com/api/f1/'.freeze
    private_constant :BASE_PATH

    class << self

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

      private

      def get(path)
        Net::HTTP.get(URI(path))
      end

      def parse(response)
        JSON.parse(response)
      end

      def drivers_path(year)
        "#{BASE_PATH}#{year}/driverstandings.json".freeze
      end

      def driver_standings(drivers_parsed_resp)
        drivers_parsed_resp['MRData']['StandingsTable']['StandingsLists']
            .first['DriverStandings']
      end

    end

  end
end
