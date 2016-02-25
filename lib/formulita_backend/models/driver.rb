module FormulitaBackend
  class Driver

    attr_reader :code, :nationality, :team, :points

    def initialize(code, nationality, team, points)
      @code = code
      @nationality = nationality
      @team = team
      @points = points
    end

    def to_h
      { code: code, nationality: nationality, team: team, points: points }
    end

  end
end
