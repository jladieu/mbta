# Question 1
```bash
% bundle exec rake 'mbta:get_subways'
Red Line
Mattapan Trolley
Orange Line
Green Line B
Green Line C
Green Line D
Green Line E
Blue Line
```

# Question 2.1 & 2.2
```bash
% bundle exec rake mbta:get_stop_counts

Mattapan Trolley has the fewest stops: 8
Green Line E has the most stops: 25
```

# Question 2.3
```bash
% bundle exec rake 'mbta:get_connecting_stops'
Park Street connects (Red Line, Green Line B, Green Line C, Green Line D, Green Line E)
Downtown Crossing connects (Red Line, Orange Line)
Ashmont connects (Red Line, Mattapan Trolley)
State connects (Orange Line, Blue Line)
Haymarket connects (Orange Line, Green Line D, Green Line E)
North Station connects (Orange Line, Green Line D, Green Line E)
Government Center connects (Green Line B, Green Line C, Green Line D, Green Line E, Blue Line)
Boylston connects (Green Line B, Green Line C, Green Line D, Green Line E)
Arlington connects (Green Line B, Green Line C, Green Line D, Green Line E)
Copley connects (Green Line B, Green Line C, Green Line D, Green Line E)
Hynes Convention Center connects (Green Line B, Green Line C, Green Line D)
Kenmore connects (Green Line B, Green Line C, Green Line D)
Science Park/West End connects (Green Line D, Green Line E)
Lechmere connects (Green Line D, Green Line E)
```

# Question 3
```bash
% bundle exec rake 'mbta:get_stops[Red Line]'

Alewife
Davis
Porter
Harvard
Central
Kendall/MIT
Charles/MGH
Park Street
Downtown Crossing
South Station
Broadway
Andrew
JFK/UMass
Savin Hill
Fields Corner
Shawmut
Ashmont
North Quincy
Wollaston
Quincy Center
Quincy Adams
Braintree

% bundle exec rake 'mbta:get_stops[Blue Line]'

Bowdoin
Government Center
State
Aquarium
Maverick
Airport
Wood Island
Orient Heights
Suffolk Downs
Beachmont
Revere Beach
Wonderland

% % bundle exec rake 'mbta:get_path_routes[Porter,Airport]'
Porter to Airport -> Red Line, Orange Line, Blue Line
```

# For fun:
```bash
% bundle exec rake 'mbta:get_path[Porter,Airport]'
Porter to Airport -> Porter, Harvard, Central, Kendall/MIT, Charles/MGH, Park Street, Downtown Crossing, State, Aquarium, Maverick, Airport
```