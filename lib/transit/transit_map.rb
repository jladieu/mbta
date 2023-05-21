require 'graph'

# A class representing a map of a transit system as a list of Routes, each with many Stops.
#
# This class is designed to be initialized from a DSL using TransitMap.configure, but it could be initialized from any data source.
module Transit
  class TransitMap
    attr_reader :routes
    attr_reader :stops
    attr_reader :graph

    def initialize(name, routes, stops, graph)
      @name = name
      @routes = routes
      @stops = stops
      @graph = graph
    end

    # DSL builder for a TransitMap, primarily to to aid in testing but with the nice benefit
    # of making building an in-memory transit map easier. Inspired by
    # https://thoughtbot.com/blog/writing-a-domain-specific-language-in-ruby
    #
    # For usage examples, see transit_map_spec.rb
    def self.configure(name, &block)
      config = Configurator.new(name)
      config.instance_eval(&block)

      return TransitMap.new(config.name, config.routes, config.stops, config.graph)
    end

    def find_path(start_stop_id, end_stop_id, &block)
      raise "Start stop #{start_stop_id} not found" unless @stops[start_stop_id]
      raise "End stop #{end_stop_id} not found" unless @stops[end_stop_id]

      Graph::BfsVisitor.find_path(@graph.get_node(start_stop_id), @graph.get_node(end_stop_id), &block)
    end

    # Returns the routes taken to travel from the start stop to the end stop.
    def find_path_routes(start_stop_id, end_stop_id)
      path = find_path(start_stop_id, end_stop_id)

      return nil unless path.present?

      route_ids = path.each_with_index.map do |node, index|
        if next_node = path[index + 1]
          node.metadata_for(next_node)
        end
      end.compact.uniq

      route_ids.map { |route_id| @routes[route_id]}
    end
  end
end