require 'transit/route'
require 'transit/stop'
require 'transit/transit_map'
require 'graph'

require 'active_support/core_ext/object/blank' # for Object#present?

module Transit
  def self.configure(name, &block)
    raise 'block is required for DSL-based configuration' unless block_given?
    config = Configurator.new(name)
    config.instance_eval(&block)
    return config.build_map
  end

  # DSL for a TransitMap, primarily to to aid in expressive test setup, but also
  # has the dual use of being usable to build the in-memory transit map. Inspired
  # by https://thoughtbot.com/blog/writing-a-domain-specific-language-in-ruby
  #
  # Usage:
  #   Transit.configure('My Transit Map') do
  #     route 'A' do
  #       stop '1'
  #       stop '2'
  #       stop '3'
  #     end
  #     route 'B' do
  #       stop '3'
  #       stop '4'
  #       stop '5'
  #     end
  #   end
  #
  # For more examples, see transit/configurator_spec.rb
  class Configurator
    attr_reader :name, :routes, :stops, :graph

    def initialize(name)
      @name = name
      @routes = {}
      @stops = {}
      @graph = Graph::Undirected.new
    end

    def route(id, name=nil, &block)
      raise 'route id is required' unless id.present?
      RouteConfigurator.new(id, name, self).tap do |route_config|
        route_config.instance_eval(&block) if block_given?
        @routes[id] = route_config.route
      end
    end

    # ensure the stop has been registered in the transit map; if not, create it;
    # return a reference in either case
    def register_stop(id, name)
      @graph.add_node(Graph::Node.new(id))
      @stops[id] ||= Stop.new(id, name)
    end

    def connect_stops(stop1, stop2, connecting_route)
      @graph.add_edge(stop1.id, stop2.id, metadata=connecting_route.id)
    end

    def build_map
      TransitMap.new(@name, @routes, @stops, @graph)
    end
  end

  # DSL for the inner block of a Route configuration
  class RouteConfigurator
    attr_reader :route

    def initialize(id, name=nil, transit_map_config)
      @transit_map_config = transit_map_config
      @route = Route.new(id, name.presence || id)
    end

    def stop(id, name=nil)
      raise 'stop id is required' unless id.present?
      stop = @transit_map_config.register_stop(id, name.presence || id)

      # keep track of all routes that pass through a given stop
      stop.routes.add(@route)

      previous_stop = @route.stops.last

      @route.stops << stop

      # if this isn't the first stop on the route, connect it to the previous stop
      if previous_stop
        @transit_map_config.connect_stops(stop, previous_stop, @route)
      end

      return stop
    end
  end
end