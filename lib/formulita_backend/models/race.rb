require 'time'

module FormulitaBackend
  class Race

    attr_reader :year, :round, :country, :date, :time

    def initialize(year, round, country, date, time)
      @year = year
      @round = round
      @country = country
      @date = date
      @time = time
    end

    def start_date
      days_before = country == 'Monaco' ? 3 : 2
      (DateTime.parse(date) - days_before).strftime('%Y-%m-%d')
    end

    def to_h
      { year: year,
        round: round,
        country: country,
        date: date,
        time: time }
    end

  end
end
