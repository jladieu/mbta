require 'mbta_client'

MBTA_CLIENT = MbtaClient.new(
  base_url: 'https://api-v3.mbta.com',
  api_key: Rails.application.credentials.mbta[:api_key],
)