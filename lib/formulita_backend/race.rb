require 'time'

module FormulitaBackend
  class Race

    attr_reader :year, :round, :country, :end_date

    def initialize(year, round, country, end_date)
      @year = year
      @round = round
      @country = country
      @end_date = end_date
    end

    def to_h
      { year: year,
        round: round,
        country: country,
        end_date: end_date }
    end

  end
end
