module Transit
  class Route
    attr_reader :id, :name, :stops

    def initialize(id, name)
      @id = id
      @name = name
      @stops = []
    end

    def stop_ids
      @stops.map(&:id)
    end

    def stop_count
      @stops.size
    end

    def connecting_stops
      @stops.select { |stop| stop.routes.size > 1 }
    end

    def intersecting_routes
      connecting_stops.flat_map(&:routes).uniq
    end

    def to_s
      "Route[#{@id} - #{@name}]"
    end

    def inspect
      to_s
    end
  end
end