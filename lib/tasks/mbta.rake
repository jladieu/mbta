
namespace :mbta do
  # This produces an answer to Question 1: List all long names of subway routes to the console.
  #
  # It sends a filter to the Server API to only fetch data for subway lines rather than loading them all and filtering them in the client.
  #
  # This allows the API to own this responsibility and reduces the amount of data transferred over the network.
  #
  task :get_subways => :environment do
    MBTA_CLIENT.fetch_subway_routes.each do |subway|
      puts subway.long_name
    end
  end

  task :get_stops, [:long_name] => :environment do |task, args|
    raise "Usage: bundle exec rake \"mbta:get_stops[Red Line]\"" unless args[:long_name].present?
    subways = get_subways_with_stops
    red_line = subways.find { |subway| subway.long_name == args[:long_name] }

    red_line.stops.each do |stop|
      puts stop.name
    end
  end

  task :get_stop_counts => :environment do
    subways = get_subways_with_stops

    sorted_by_stop_count = subways.sort_by(&:stop_count)

    fewest_stops = sorted_by_stop_count.first
    most_stops = sorted_by_stop_count.last
    
    puts "#{fewest_stops.long_name} has the fewest stops: #{fewest_stops.stop_count}"
    puts "#{most_stops.long_name} has the most stops: #{most_stops.stop_count}"
  end

  task :get_connecting_stops => :environment do
    subways = get_subways_with_stops
    unique_stops = subways.map(&:stops).flatten.uniq

    hydrate_stops_with_subways(unique_stops, subways)

    unique_stops.each do |stop|
      if stop.subway_count > 1
        puts "#{stop.name} connects [#{stop.subways.map(&:long_name).join(', ')}]"
      end
    end
  end

  def get_subways_with_stops
    MBTA_CLIENT.fetch_subway_routes.tap do |subways|
      subways.each do |subway|
        subway.stops = MBTA_CLIENT.fetch_stops(subway.id)
      end
    end
  end

  def hydrate_stops_with_subways(stops, subways)
    stops.each do |stop|
      connected_subways = []
      subways.each do |subway|
        if subway.stop_ids.include?(stop.id)
          connected_subways.push(subway)
        end
      end
      stop.subways = connected_subways
    end
  end
end