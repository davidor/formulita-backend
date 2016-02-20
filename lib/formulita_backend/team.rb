module FormulitaBackend
  class Team

    attr_accessor :name, :nationality, :points

    def initialize(name, nationality, points)
      @name = name
      @nationality = nationality
      @points = points
    end

    def to_h
      { name: name,
        nationality: nationality,
        points: points }
    end

  end
end
