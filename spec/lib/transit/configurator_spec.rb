require 'rails_helper'
require 'transit/configurator'

describe Transit::Configurator do
  describe '.configure' do
    it 'defaults to using the id as a name if no names are provided' do
      map = Transit.configure 'simple' do
        route 'letters' do
          stop 'a'
          stop 'b'
          stop 'c'
        end
      end

      expect(map.routes.size).to eq(1)
      only_route = map.routes['letters']
      expect(only_route.id).to eq('letters')
      expect(only_route.name).to eq('letters')

      expect(map.stops.size).to eq(3)
      expect(map.stops['a'].id).to eq('a')
      expect(map.stops['a'].name).to eq('a')
      expect(map.stops['b'].id).to eq('b')
      expect(map.stops['b'].name).to eq('b')
      expect(map.stops['c'].id).to eq('c')
      expect(map.stops['c'].name).to eq('c')
    end

    it 'allows human friendly names to be specified' do
      map = Transit.configure 'simple' do
        route 'n', 'Names' do
          stop 'a', 'Alice'
          stop 'b', 'Bob'
        end
      end

      expect(map.routes.size).to eq(1)
      only_route = map.routes['n']
      expect(only_route.id).to eq('n')
      expect(only_route.name).to eq('Names')

      expect(map.stops.size).to eq(2)
      expect(map.stops['a'].id).to eq('a')
      expect(map.stops['a'].name).to eq('Alice')
      expect(map.stops['b'].id).to eq('b')
      expect(map.stops['b'].name).to eq('Bob')
    end

    it 'can create a realistic TransitMap using the DSL with human-friendly names' do
      mini_mbta = Transit.configure 'mini MBTA' do
        # Define a directed graph describing the Red line, stop order matters.  The first
        # listed stop is the origin station and the last listed stop is the destination stop.
        # Sequential stops are connected.  Routes are not assumed to be bidirectional.
        route 'red', 'Redline Southbound' do
          stop 'place-alfcl', 'Alewife'
          stop 'place-davis', 'Davis'
          stop 'place-portr', 'Porter'
          stop 'place-harsq', 'Harvard'
          stop 'place-cntsq', 'Central'
          stop 'place-knncl', 'Kendall/MIT'
          stop 'place-chmnl', 'Charles/MGH'
          stop 'place-pktrm', 'Park Street'
          stop 'place-dwnxg', 'Downtown Crossing'
          stop 'place-sstat', 'South Station'
          stop 'place-brdwy', 'Broadway'
          stop 'place-andrw', 'Andrew'
          stop 'place-jfk', 'JFK/UMass'
          stop 'place-shmnl', 'Savin Hill'
          stop 'place-fldcr', 'Fields Corner'
          stop 'place-smmnl', 'Shawmut'
          stop 'place-asmnl', 'Ashmont'
        end

        route 'orange', 'Orange Line Westbound' do
          stop 'place-ogmnl', 'Oak Grove'
          stop 'place-mlmnl', 'Malden Center'
          stop 'place-welln', 'Wellington'
          stop 'place-sull', 'Sullivan Square'
          stop 'place-ccmnl', 'Community College'
          stop 'place-north', 'North Station'
          stop 'place-haecl', 'Haymarket'
          stop 'place-state', 'State Street'
          stop 'place-dwnxg', 'Downtown Crossing'
          stop 'place-chmnl', 'Chinatown'
          stop 'place-tumnl', 'Tufts Medical Center'
          stop 'place-bbsta', 'Back Bay'
          stop 'place-masta', 'Massachusetts Avenue'
          stop 'place-rugg', 'Ruggles'
          stop 'place-rcmnl', 'Roxbury Crossing'
          stop 'place-jaksn', 'Jackson Square'
          stop 'place-sbmnl', 'Stony Brook'
          stop 'place-grnst', 'Green Street'
        end
      end

      expect(mini_mbta.routes.count).to eq(2)
      expect(mini_mbta.routes.keys).to eq(['red', 'orange'])

      redline = mini_mbta.routes['red']

      expect(redline.stop_ids.count).to eq(17)

      alewife_id = redline.stop_ids.first
      expect(alewife_id).to eq('place-alfcl')
    end
  end
end