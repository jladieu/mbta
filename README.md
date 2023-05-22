# README

# Overview
This is a mini Rails app to implement the integration with the MBTA API for the coding challenge.  However, the Rails app is really just a wrapper for a command line script that is executed using `rake`.  I initially thought I'd provide a cURL-based API but quickly realized Rake would require a lot less bootstrapping.  This probably would be better implemented as a 'ruby gem' which is a much lighter weight construct, but figured having the extra boilerplate wouldn't be too much of a distraction if I provided some rough pointers to the interesting stuff.  There's no database or web server to deal with.

Interesting stuff:
- [lib/tasks/mbta.rake](lib/tasks/mbta.rake) - This is the top level entry point for the Rake tasks which are explicitly answer the coding challenge questions.
- [lib/graph](lib/graph) - This package contains the graph implementation used to do pathing logic.
- [lib/transit](lib/transit) - This package contains the model classes for a transit system, as well as a Transit::Configurator for setting one up with an easy-to-use DSL that is helpful for expressing the transit system in test cases.
- [lib/mbta_client.rb](lib/mbta_client.rb) - This contains the actual HTTP interaction with the MBTA API.
- [lib/mbta_transit_map_loader.rb](lib/mbta_transit_map_loader.rb) - This contains the logic to bridge the data from the MBTA API into the Transit::Configurator to get the data model loaded up to answer the questions.
- [spec/lib](spec/lib) - This is where all the test cases live.  I thought defining a transit map might be gnarly and ugly so I spent a bunch of extra time setting up a DSL that made it easier to express the test fixture in a human-readable format.

# Setup notes:
This Rails app was built * tested on Mac OS Ventura 13.3.1 using VSCode 1.78.2.

- Install [homebrew](https://brew.sh/) (4.0.18) using CLI
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```
- Install [rbenv](https://github.com/rbenv/rbenv) (1.2.0) using Homebrew
  ```bash
  brew install rbenv ruby-build
  rbenv init
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  ```
- Install [ruby](https://www.ruby-lang.org/en/) (3.2.2) using rbenv
  ```bash
  rbenv install 3.2.2
  rbenv global 3.2.2
  ```
- Check out this repo
  ```bash
  git clone https://github.com/jladieu/mbta
  ```
- Download dependencies
  ```bash
  bundle install
  ```
- Run tests
  ```bash
  bundle exec rspec
  ```
- Run rake tasks to produce answers to the coding challenge problems:
  ```bash
  # Question 1
  bundle exec rake mbta:get_subways

  # Question 2.1 & 2.2
  bundle exec rake mbta:get_stop_counts

  # Question 2.3
  bundle exec rake mbta:get_connecting_stops

  # Question 3
  # List off the stops on a given route, which can be used as input to the get_path task
  bundle exec rake 'mbta:get_stops[Red Line]'
  bundle exec rake 'mbta:get_stops[Blue Line]'
  bundle exec rake 'mbta:get_path_routes[Porter,Airport]'

  # for extra fun...
  bundle exec rake 'mbta:get_path[Porter,Airport]'
  ```
- In the event that getting this to run locally is too annoying or time consuming, I've also provided sample output in [sample-output.md](sample-output.md) (_Runs on my machine!_) to at least prove that the code worked as expected _at the time of this writing_ ;)

# Design notes:
- Question 1: I went the route of using the API to do the filtering of Subway logic rather than loading it all and filtering it myself.  I thought this would be the quicker path to getting into the interesting parts of the problem, and generally had the hunch that if an API can do the work for me, I should let it.  That said, I could think of a number of reasons why we might consider going the other direction and thought I'd call those out here in no particular order:
  - If we didn't want to have a hard dependency on the MBTA API, maybe we could just load up everything and cache it locally for rapid iteration.
  - Maybe we don't trust the MBTA API and want to really double check the data before using it.
  - Maybe we want to do some additional filtering / logic that the API doesn't support.
- I had to dust off some knowledge of graphs.  This was a helpful resource: https://www.sitepoint.com/graph-algorithms-ruby/
- Since a transit map is _probably_ going to be a sparse graph, I chose to use an adjacency list (as opposed to a matrix).
- Graph/node impl based on https://medium.com/@young.scottw/implementing-an-undirected-graph-in-ruby-c11258b3d95b
- I considered using https://github.com/monora/rgl for Graph primitives to avoid getting bogged down in the details of implementing a graph and BFS, but found it to be a bit overkill and hard to work with, so I went with my own.
- I went off on a big detour solving the challenge by trying to get the path of _actual stops_ visited.  For some reason I felt my mental model wasn't complete without having this done first.  I ended up shimming on top of this to produce the actual desired answer to Question 3, which was to just print the routes traveled.  I'm _guessing_ there's probably a simpler way to get the desired answer to Question 3, but stuck with this because I was mostly happy with where it ended up.
- I used BFS because I thought in a finding a path in the public transit domain we'd most likely be interested in crossing into other routes rather than pursuing existing lines to the very end.  I figured BFS would be more likely to find a path that crossed into other routes sooner than DFS which would crawl to the very end of the line.
