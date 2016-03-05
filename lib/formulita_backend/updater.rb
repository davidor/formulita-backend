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
      races = races(year)

      { year: year,
        races: races,
        drivers: drivers(year),
        teams: teams(year),
        qualy_results: qualy_results(year, races.size),
        race_results: race_results(year, races.size) }
    end

    def races(year)
      ergast_client.races(year)
    end

    def drivers(year)
      ergast_client.drivers(year)
    end

    def teams(year)
      ergast_client.teams(year)
    end

    def qualy_results(year, n_races)
      (1..n_races).map do |round|
        ergast_client.qualifying_results(year, round)
      end
    end

    def race_results(year, n_races)
      (1..n_races).map do |round|
        ergast_client.race_results(year, round)
      end
    end

    def write(year, json)
      File.open("#{DATA_PATH}/#{year}.json", 'w') { |file| file.write(json) }
    end

  end
end
