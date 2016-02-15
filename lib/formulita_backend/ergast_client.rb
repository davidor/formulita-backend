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
        # TODO
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

    end

  end
end
