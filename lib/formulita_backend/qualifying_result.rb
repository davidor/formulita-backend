module FormulitaBackend
  class QualifyingResult

    attr_reader :position, :driver_code, :q1, :q2, :q3

    def initialize(position, driver_code, q1, q2, q3)
      @position = position
      @driver_code = driver_code
      @q1 = q1
      @q2 = q2
      @q3 = q3
    end

    def to_h
      { position: position, driver_code: driver_code, q1: q1, q2: q2, q3: q3 }
    end

  end
end
