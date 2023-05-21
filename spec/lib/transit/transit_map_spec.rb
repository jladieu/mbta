
require 'transit/transit_map'
require 'transit/configurator'

describe Transit::TransitMap do
  describe '#find_path along a single route map' do
    let(:map) do
      Transit.configure 'single route map' do
        route 'letters' do
          stop 'a'
          stop 'b'
          stop 'c'
          stop 'd'
          stop 'e'
          stop 'f'
        end
      end
    end

    it 'returns a single element if the start and end stop ids are the same' do
      path = map.find_path('a', 'a')
      expect(path.map(&:value)).to eq(['a'])
    end

    it 'returns two stops if the end is a neighbor of the start' do
      path = map.find_path('a', 'b')

      expect(path.map(&:value)).to eq(['a', 'b'])
    end

    it 'lists multiple stops if the end is not a neighbor' do
      path = map.find_path('d', 'e')
      expect(path.map(&:value)).to eq(['d', 'e'])

      path = map.find_path('c', 'f')
      expect(path.map(&:value)).to eq(['c', 'd', 'e', 'f'])
    end

    it 'lists a reverse path if the path requires backwards traversal' do
      path = map.find_path('c', 'a')
      expect(path.map(&:value)).to eq(['c', 'b', 'a'])
    end
  end

  describe '#find_path' do
    it 'can cross routes to find a path' do
      map = Transit.configure 'simple crossing route map' do
        # Define a directed graph describing the Red line, stop order matters.  The first
        # listed stop is the origin station and the last listed stop is the destination stop.
        # Sequential stops are connected.
        route 'Red Line' do
          stop 'dtx', 'Downtown Crossing'
          stop 'park', 'Park Street'
          stop 'mgh', 'Charles/MGH'
        end

        route 'Orange Line' do
          stop 'dtx', 'Downtown Crossing'
          stop 'state', 'State Street'
          stop 'hay', 'Haymarket'
          stop 'nsta', 'North Station'
        end
      end

      path = map.find_path('mgh', 'hay').map(&:value)

      expect(path).to eq(['mgh', 'park', 'dtx', 'state', 'hay'])
    end

    it 'returns nil if it can not find a path' do
      map = Transit.configure 'parallel routes' do
        route 'numbers', 'Ascending' do
          stop '1', 'One'
          stop '2', 'Two'
          stop '3', 'Three'
        end

        route 'letters', 'Descending' do
          stop 'z', 'Z'
          stop 'y', 'Y'
          stop 'x', 'X'
        end
      end
      expect(map.find_path('1', 'z')).to be_nil
      expect(map.find_path('y', '2')).to be_nil
    end

    it 'returns a single node path if the stop/start are the same' do
      map = Transit.configure 'trivial' do
        route 'numbers', 'Ascending' do
          stop '1', 'One'
          stop '2', 'Two'
        end
      end
      expect(map.find_path('1', '1').map(&:value)).to eq(['1'])
      expect(map.find_path('2', '2').map(&:value)).to eq(['2'])
    end
  end

  describe '#find_path_routes' do
    it 'can display the routes that need to be taken to get from one stop to another' do
      map = Transit.configure 'simple crossing route map' do
        # Define a directed graph describing the Red line, stop order matters.  The first
        # listed stop is the origin station and the last listed stop is the destination stop.
        # Sequential stops are connected.
        route 'Red Line' do
          stop 'dtx', 'Downtown Crossing'
          stop 'park', 'Park Street'
          stop 'mgh', 'Charles/MGH'
        end

        route 'Orange Line' do
          stop 'dtx', 'Downtown Crossing'
          stop 'state', 'State Street'
          stop 'hay', 'Haymarket'
          stop 'nsta', 'North Station'
        end
      end

      path_routes = map.find_path_routes('mgh', 'hay')

      expect(path_routes.map(&:name)).to eq(['Red Line', 'Orange Line'])
    end

    it 'returns nil if there is no path between the given stops' do
      map = Transit.configure 'disconnected map' do
        route 'red' do
          stop '1'
        end

        route 'green' do
          stop '2'
        end
      end

      expect(map.find_path_routes('1', '2')).to be_nil
    end
  end
end
