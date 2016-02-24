module FormulitaBackend
  class RaceResult

    attr_reader :position, :driver_code, :laps, :time, :grid, :points

    def initialize(position, driver_code, laps, time, grid, points)
      @position = position
      @driver_code = driver_code
      @laps = laps
      @time = time
      @grid = grid
      @points = points
    end

    def to_h
      { position: position,
        driver: driver_code,
        laps: laps,
        time: time,
        grid: grid,
        points: points }
    end

  end
end
