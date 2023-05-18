# README

This README would normally document whatever steps are necessary to get the
application up and running.

# Setup notes:
- Install homebrew [4.0.18] -> rbenv [1.2.0] -> ruby [3.2.2] -> rails [7.0.4.3]
- Pick an HTTP library (httparty vs. faraday vs. something else?)

# Design notes:

## Routes we want to support:

1. GET /api/v1/subways # output: list long names of all lines
1. GET /api/v1/subways/most_stops # most stops + count
1. GET /api/v1/subways/fewest_stops # fewest stops + count
1. GET /api/v1/connections
1. GET /api/v1/paths/from/:from/to/:to # a path from :from to :to

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
