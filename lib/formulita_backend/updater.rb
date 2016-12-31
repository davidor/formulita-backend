module FormulitaBackend
  # Creates the JSON file that will be served from the server
  class Updater

    DATA_PATH = File.expand_path('../../../data', __FILE__).freeze
    private_constant :DATA_PATH

    def initialize(ergast_client: ErgastClient, formatter: Formatter)
      @ergast_client = ergast_client
      @formatter = formatter
    end

    def update(year)
      write(year, formatted_championship(year).to_json)
    end

    private

    attr_reader :ergast_client, :formatter

    def formatted_championship(year)
      formatter.formatted_championship(championship(year))
    end

    def championship(year)
      ergast_client.championship(year)
    end

    def write(year, json)
      File.open("#{DATA_PATH}/#{year}.json", 'w') { |file| file.write(json) }
    end

  end
end
