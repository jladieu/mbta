require 'graph'

# A class representing a map of a transit system as a list of Routes, each with one or more Stops.
#
# This class is designed to be initialized from a DSL using TransitMap.configure, but it could be initialized
# from any data source using the provided constructor.  It trusts that the provided routes, stops, and graph
# are consistent with each other.
module Transit
  class TransitMap
    # Args:
    #  name: name of the transit map
    #  routes: hash of routes (key is route id, value is Route)
    #  stops: hash of stops (key is stop id, value is Stop)
    #  graph: graph of stops and routes (see lib/graph)
    def initialize(name, routes, stops, graph)
      @name = name
      @routes = routes
      @stops = stops
      @graph = graph
    end

    # Returns the shortest path between the start stop and the end stop.  Accepts either stop ID or name.
    # Returns nil if no path can be found.
    def find_path(start_id_or_name, end_id_or_name, &block)
      start_stop = find_stop_by_id_or_name(start_id_or_name)
      end_stop = find_stop_by_id_or_name(end_id_or_name)
      raise "Start stop #{start_id_or_name} not found" unless start_stop
      raise "End stop #{end_id_or_name} not found" unless end_stop

      Graph::BfsVisitor.find_path(@graph.get_node(start_stop.id), @graph.get_node(end_stop.id), &block)
    end

    # Returns the routes taken to travel from the start stop to the end stop.  Accepts either stop ID or name.
    # Returns nil if no path can be found.
    def find_path_routes(start_id_or_name, end_id_or_name)
      path = find_path(start_id_or_name, end_id_or_name)

      return nil unless path.present?

      route_ids = path.each_with_index.map do |node, index|
        if next_node = path[index + 1]
          node.metadata_for(next_node)
        end
      end.compact.uniq

      route_ids.map { |route_id| @routes[route_id]}
    end

    def routes
      @routes.values
    end

    def get_route(id)
      @routes[id]
    end

    def stops
      @stops.values
    end

    def find_stop_by_id_or_name(id_or_name)
      @stops[id_or_name] || @stops.values.find { |stop| stop.name == id_or_name }
    end

    def get_stop(id)
      @stops[id]
    end
  end
end