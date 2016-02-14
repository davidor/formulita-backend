module FormulitaBackend
  class Team

    attr_accessor :name, :nationality, :points

    def initialize(name, nationality, points)
      @name = name
      @nationality = nationality
      @points = points
    end

    def to_json
      { name: @name,
        nationality: @nationality,
        points: @points }.to_json
    end

  end
end
