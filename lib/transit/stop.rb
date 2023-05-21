module Transit
  class Stop
    attr_reader :id, :name
    attr_accessor :routes

    def initialize(id, name)
      @id = id
      @name = name
      @routes = Set.new
    end

    def to_s
      "Stop[#{@id} - #{@name}]"
    end

    def inspect
      to_s
    end

    def intersection?
      @routes.size > 1
    end
  end
end