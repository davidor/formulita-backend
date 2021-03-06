module FormulitaBackend
  # Converts the data retrieved from the Ergast service to the format expected
  # by the Android app.
  class Formatter

    DRIVER_NAMES_FILE = File.expand_path('../../../data/driver_names.json', __FILE__)
    private_constant :DRIVER_NAMES_FILE

    COUNTRIES_FILE = File.expand_path('../../../data/countries.json', __FILE__)
    private_constant :COUNTRIES_FILE

    DRIVER_NAMES = JSON.parse(File.read(DRIVER_NAMES_FILE))
    private_constant :DRIVER_NAMES

    COUNTRIES = JSON.parse(File.read(COUNTRIES_FILE))
    private_constant :COUNTRIES

    class << self

      def formatted_championship(championship)
        year = championship[:year]
        { year: year,
          races: formatted_races(championship[:races],
                                 championship[:qualy_results],
                                 championship[:race_results]),
          drivers: formatted_drivers(year, championship[:drivers]),
          teams: formatted_teams(year, championship[:teams]) }
      end

      private

      def formatted_races(races, qualy_results, race_results)
        races.each_with_index.map do |race, index|
          { year: race[:year],
            number: race[:round],
            country: formatted_country(race[:country]),
            startDate: formatted_date_time(
                start_date(race[:date], race[:country]), race[:time]),
            endDate: formatted_date_time(race[:date], race[:time]),
            winner: formatted_winner(race_results[index]),
            qualyResults: formatted_results(qualy_results[index]),
            raceResults: formatted_results(race_results[index]) }
        end
      end

      def formatted_winner(results)
        results.empty? ? '' : driver_name(results.first[:driver_code])
      end

      def formatted_results(results)
        results.map do |result|
          driver = driver_name(result[:driver_code])
          result.tap { |res| res.delete(:driver_code) }.merge(driver: driver)
        end
      end

      def formatted_drivers(year, drivers)
        drivers.each_with_index.map do |driver, index|
          { name: driver_name(driver[:code]),
            country: country(driver[:nationality]),
            team: driver[:team],
            points: driver[:points],
            year: year,
            position: index + 1 }
        end
      end

      def formatted_teams(year, teams)
        teams.each_with_index.map do |team, index|
          { name: team[:name],
            country: country(team[:nationality]),
            points: team[:points],
            year: year,
            position: index + 1 }
        end
      end

      def formatted_date_time(date, time)
        "#{date}T#{time}"
      end

      def start_date(race_date, country)
        days_before = country == 'Monaco' ? 3 : 2
        (DateTime.parse(race_date) - days_before).strftime('%Y-%m-%d')
      end

      def formatted_country(country)
        # The Android application expects different names. To be solved.
        return 'Abu Dhabi' if country == 'UAE'
        return 'G.Britain' if country == 'UK'
        country
      end

      def country(nationality)
        COUNTRIES[nationality]
      end

      def driver_name(driver_code)
        DRIVER_NAMES[driver_code]
      end

      def driver(drivers, code)
        drivers.find { |driver| driver[:code] == code }
      end

    end

  end
end
