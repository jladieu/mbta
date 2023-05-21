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

    def connecting_stops
      @stops.select { |stop| stop.routes.size > 1 }
    end

    def intersecting_routes
      connecting_stops.flat_map(&:routes).uniq
    end
  end
end