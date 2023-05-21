require 'mbta_client'
require 'graph'
require 'transit'

class MbtaTransitMapLoader
  def initialize(mbta_client)
    @mbta_client = mbta_client
  end

  def load_subway_map
    config = Transit::Configurator.new('MBTA')
    routes = @mbta_client.fetch_subway_routes

    routes.each do |route_id, route_name|
      stops = @mbta_client.fetch_stops(route_id)
      config.route(route_id, route_name).tap do |route_config|
        stops.each do |stop_id, stop_name|
          route_config.stop(stop_id, stop_name)
        end
      end
    end

    config.build_map
  end
end