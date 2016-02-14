module FormulitaBackend
  class Driver

    attr_reader :first_name, :last_name, :nationality, :team, :points

    def initialize(first_name, last_name, nationality, team, points)
      @first_name = first_name
      @last_name = last_name
      @nationality = nationality
      @team = team
      @points = points
    end

    def formatted_name
      "#{first_name[0]}.#{last_name}"
    end

    def to_json
      { first_name: @first_name,
        last_name: @last_name,
        nationality: @nationality,
        team: @team,
        points: @points }.to_json
    end

  end
end
