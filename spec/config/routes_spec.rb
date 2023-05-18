require 'rails_helper'

RSpec.describe 'all routes', type: :routing do
  it 'routes api/v1/subways to subways#index' do
    expect(get('/api/v1/subways')).to route_to('api/v1/subways#index')
  end

  it 'routes api/v1/most_stops to subways#most_stops' do
    expect(get('/api/v1/subways/most_stops')).to route_to('api/v1/subways#most_stops')
  end

  it 'routes api/v1/least_stops to subways#least_stops' do
    expect(get('/api/v1/subways/least_stops')).to route_to('api/v1/subways#least_stops')
  end

  it 'routes api/v1/stops/connections to stops#connections' do
    expect(get('/api/v1/stops/connections')).to route_to('api/v1/stops#connections')
  end

  it 'routes api/v1/paths/from/:from/to/:to to paths#index' do
    expect(get('/api/v1/paths/from/xyz/to/abc')).to route_to('api/v1/paths#index', from: 'xyz', to: 'abc')
  end
end