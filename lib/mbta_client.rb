require 'faraday'
require 'json'

# A simple HTTP-based client of the MBTA API.
class MbtaClient

  # See [route_type](https://github.com/google/transit/blob/master/gtfs/spec/en/reference.md#routestxt) in the GTFS spec for the comprehensive list.
  SUBWAY_ROUTE_TYPES = [
    0, # Light rail,
    1, # Heavy rail
  ]

  def initialize(params = {})
    @base_url = params[:base_url].presence or raise 'base_url is required'
    @api_key = params[:api_key].presence or raise 'api_key is required'
  end

  # Fetches only routes that have subway route types from the API.  Returns
  # an array of [route_id, route_name] pairs.  For discussion on why this approach was
  # chosen, see the first bullet of the Design Notes in the README.md
  def fetch_subway_routes
    fields = ['long_name']

    parsed_results = fetch_and_parse do
      connection.get('/routes') do |request|
        request.params['filter[type]'] = SUBWAY_ROUTE_TYPES.join(',')
        request.params['fields[route]'] = fields.join(',')
      end
    end

    parsed_results.map do |hash|
      raise "Unexpected type #{hash['type']}" unless hash['type'] == 'route'
      [hash['id'], hash['attributes']['long_name']]
    end
  end

  # Fetches all stops for a given route.  Returns an array of [stop_id, stop_name] pairs.
  def fetch_stops(route_id)
    fields = ['name']
    parsed_results = fetch_and_parse do
      connection.get("/stops") do |request|
        request.params['filter[route]'] = route_id
        request.params['fields[stop]'] = fields.join(',')
      end
    end

    parsed_results.map do |hash|
      raise "Unexpected type #{hash['type']}" unless hash['type'] == 'stop'
      [hash['id'], hash['attributes']['name']]
    end
  end

  private

  def fetch_and_parse(&block)
    response = block.call
    result = JSON.parse(response.body)
    result['data']
  end

  def connection
    @connection ||= Faraday.new(
      url: @base_url,
      headers: { 'x-api-key': @api_key}
    )
  end
end