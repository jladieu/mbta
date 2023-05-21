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

Graph algorithms resources:
- https://www.sitepoint.com/graph-algorithms-ruby/

Transit map is going to be a sparse graph, so let's use an adjacency list (as opposed to a matrix).

Each node will represent a Stop, and adjacent stops will be connected by an edge.

Each node will represent a Stop, and stops have a unique ID so use impl here which allows quick lookup based on hash: https://medium.com/@young.scottw/implementing-an-undirected-graph-in-ruby-c11258b3d95b

Use https://github.com/monora/rgl for Graph primitives to avoid getting bogged down in the details of implementing a graph.  This also allow us to swap out algorithms easily or extend functionality.

We also want to hold onto route information in the graph nodes, so we need the unique id to include both RouteId + StopId.  To represent connecting stops, we will need to provide a node for _every_ route with the given stop.

So for example, Park Street would have a node for the Red Line and a node for the Green Line, represented as [red:parkstreet, green:parkstreet] which would have edges.


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
