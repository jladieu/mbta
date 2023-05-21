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

  # Fetches only routes that have subway route types from the API.
  def fetch_subway_routes
    fields = ['long_name']

    parsed_results = fetch_and_parse do
      connection.get('/routes') do |request|
        request.params['filter[type]'] = SUBWAY_ROUTE_TYPES.join(',')
        request.params['fields[route]'] = fields.join(',')
      end
    end
    
    parsed_results.map { |result| Subway.from_parsed_json(result) }
  end

  def fetch_stops(route_id)
    fields = ['name']
    parsed_results = fetch_and_parse do 
      connection.get("/stops") do |request|
        request.params['filter[route]'] = route_id
        request.params['fields[stop]'] = fields.join(',')
      end
    end

    parsed_results.map { |result| Stop.from_parsed_json(result) }
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