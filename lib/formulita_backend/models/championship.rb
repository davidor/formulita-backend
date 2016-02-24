module FormulitaBackend
  class Championship

    attr_reader :year, :races, :drivers, :teams, :qualy_results, :race_results

    def initialize(year, races, drivers, teams, qualy_results, race_results)
      @year = year
      @races = races
      @drivers = drivers
      @teams = teams
      @qualy_results = qualy_results
      @race_results = race_results
    end

  end
end
