module FormulitaBackend
  # Converts the data retrieved from the Ergast service to the format expected
  # by the Android app.
  class Formatter

    DRIVER_CODES_FILE = File.expand_path('../../../data/driver_codes.json', __FILE__)
    private_constant :DRIVER_CODES_FILE

    NATIONALITIES_FILE = File.expand_path('../../../data/nationalities.json', __FILE__)
    private_constant :NATIONALITIES_FILE

    DRIVER_CODES = JSON.parse(File.read(DRIVER_CODES_FILE))
    private_constant :DRIVER_CODES

    NATIONALITIES = JSON.parse(File.read(NATIONALITIES_FILE))
    private_constant :NATIONALITIES

    class << self

      def formatted_championship(championship)
        year = championship.year
        { year: year,
          races: formatted_races(championship.races,
                                 championship.qualy_results,
                                 championship.race_results,
                                 championship.drivers),
          drivers: formatted_drivers(year, championship.drivers),
          teams: formatted_teams(year, championship.teams) }.to_json
      end

      private

      def formatted_races(races, qualy_results, race_results, drivers)
        races.each_with_index.map do |race, index|
          { year: race.year,
            number: race.round,
            country: formatted_country(race.country),
            startDate: formatted_time(DateTime.parse(race.start_date)),
            endDate: formatted_time(DateTime.parse(race.end_date)),
            winner: driver_name(race_results[index].first.driver_code),
            qualyResults: formatted_qualy_results(qualy_results[index], drivers),
            raceResults: formatted_race_results(race_results[index], drivers) }
        end
      end

      def formatted_qualy_results(qualy_results, drivers)
        qualy_results.map do |result|
          { position: result.position,
            driver: driver_name(result.driver_code),
            team: driver(drivers, result.driver_code).team,
            q1: result.q1,
            q2: result.q2,
            q3: result.q3 }
        end
      end

      def formatted_race_results(race_results, drivers)
        race_results.map do |result|
          { position: result.position,
            driver: driver_name(result.driver_code),
            team: driver(drivers, result.driver_code).team,
            laps: result.laps,
            time: result.time,
            grid: result.grid,
            points: result.points }
        end
      end

      def formatted_drivers(year, drivers)
        drivers.each_with_index.map do |driver, index|
          { name: driver_name(driver.code),
            country: country(driver.nationality),
            team: driver.team,
            points: driver.points,
            year: year,
            position: index + 1 }
        end
      end

      def formatted_teams(year, teams)
        teams.each_with_index.map do |team, index|
          { name: team.name,
            country: country(team.nationality),
            points: team.points,
            year: year,
            position: index + 1 }
        end
      end

      def formatted_time(time_utc)
        time_utc.strftime('%Y-%m-%dT%TZ')
      end

      def formatted_country(country)
        # The Android application expects different names. To be solved.
        return 'Abu Dhabi' if country == 'UAE'
        return 'G.Britain' if country == 'UK'
        country
      end

      def country(nationality)
        NATIONALITIES[nationality]
      end

      def driver_name(driver_code)
        DRIVER_CODES[driver_code]
      end

      def driver(drivers, code)
        drivers.find { |driver| driver.code == code }
      end

    end

  end
end
