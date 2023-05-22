require 'mbta_transit_map_loader'

namespace :mbta do

  # Question 1
  #
  # It sends a filter to the Server API to only fetch data for subway lines rather than loading them all and filtering them in the client.
  #
  # This allows the API to own this responsibility and reduces the amount of data transferred over the network.
  task :get_subways => :environment do
    puts load_subway_map.routes.map(&:name)
  end

  task :get_stops, [:name] => :environment do |task, args|
    raise "Usage: bundle exec rake \"mbta:get_stops[Red Line]\"" unless args[:name].present?
    route = load_subway_map.routes.find { |route| route.name == args[:name] }

    raise "Route #{args[:name]} not found" unless route.present?
    route.stops.each do |stop|
      puts stop.name
    end
  end

  # Question 2.1 & 2.2
  task :get_stop_counts => :environment do
    sorted_by_stop_count = load_subway_map.routes.sort_by(&:stop_count)

    fewest_stops = sorted_by_stop_count.first
    most_stops = sorted_by_stop_count.last

    puts "#{fewest_stops.name} has the fewest stops: #{fewest_stops.stop_count}"
    puts "#{most_stops.name} has the most stops: #{most_stops.stop_count}"
  end

  # Question 2.3
  task :get_connecting_stops => :environment do
    all_stops = load_subway_map.routes.flat_map(&:stops).uniq

    all_stops.select(&:intersection?).each do |stop|
      puts "#{stop.name} connects (#{stop.routes.map(&:name).join(', ')})"
    end
  end

  # Question 3
  task :get_path_routes, [:from, :to] => :environment do |task, args|
    raise "Usage: bundle exec rake \"mbta:get_path_routes[Porter,Airport]\"" unless args[:from].present? && args[:to].present?

    routes = load_subway_map.find_path_routes(args[:from], args[:to])

    if routes.present?
      puts "#{args[:from]} to #{args[:to]} -> #{routes.map(&:name).join(', ')}"
    else
      puts "No path found"
    end
  end

  # supplement, prints the stops along the path
  task :get_path, [:from, :to] => :environment do |task, args|
    raise "Usage: bundle exec rake \"mbta:get_path[Porter,Airport]\"" unless args[:from].present? && args[:to].present?
    map = load_subway_map
    path = map.find_path(args[:from], args[:to])

    if path.present?
      stop_names = path.map(&:value).map { |stop_id| map.get_stop(stop_id).name }
      puts "#{args[:from]} to #{args[:to]} -> #{stop_names.join(', ')}"
    else
      puts "No path found"
    end
  end

  def load_subway_map
    @subway_map ||= MbtaTransitMapLoader.new(MBTA_CLIENT).load_subway_map
  end
end