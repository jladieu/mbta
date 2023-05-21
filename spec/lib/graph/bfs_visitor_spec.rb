require 'rails_helper'
require 'graph'

describe Graph::BfsVisitor do
  it 'correctly traverses a simple undirected graph' do
    graph = Graph::Undirected.new

    a = graph.add_node(node('a'))
    b = graph.add_node(node('b'))
    c = graph.add_node(node('c'))
    d = graph.add_node(node('d'))
    e = graph.add_node(node('e'))
    f = graph.add_node(node('f'))

    graph.add_edge('a', 'b')
    graph.add_edge('a', 'c')

    graph.add_edge('b', 'a')
    graph.add_edge('b', 'd')

    graph.add_edge('c', 'b')
    graph.add_edge('c', 'e')
    
    graph.add_edge('d', 'f')

    graph.add_edge('e', 'f')

    visited = []
    Graph::BfsVisitor.visit(a) do |node|
      visited << node.value
    end

    expect(visited).to eq(['a', 'b', 'c', 'd', 'e', 'f'])
  end

  it 'correctly traverses a linear bidirectional graph when starting from a middle node' do
    graph = Graph::Undirected.new

    a = graph.add_node(node('a'))
    b = graph.add_node(node('b'))
    c = graph.add_node(node('c'))
    d = graph.add_node(node('d'))
    e = graph.add_node(node('e'))

    # [a] <-> [b] <-> [c] <-> [d] <-> [e]
    graph.add_edge('a', 'b')
    graph.add_edge('b', 'a')

    graph.add_edge('b', 'c')
    graph.add_edge('c', 'b')

    graph.add_edge('c', 'd')
    graph.add_edge('d', 'c')

    graph.add_edge('d', 'e')
    graph.add_edge('e', 'd')

    visited = []
    Graph::BfsVisitor.visit(c) do |node|
      visited << node.value
    end

    expect(visited).to eq(['c', 'b', 'd', 'a', 'e'])
  end

  it 'also provides a predecessor node and metadata for each visited node for path gathering' do
    graph = Graph::Undirected.new

    a = graph.add_node(node('a'))
    b = graph.add_node(node('b'))
    c = graph.add_node(node('c'))
    
    graph.add_edge('a', 'b', metadata='foo')
    graph.add_edge('b', 'c', metadata='bar')

    predecessors = []
    all_metadata = []
    visited = []
    Graph::BfsVisitor.visit(a) do |node, predecessor, metadata|
      predecessors << predecessor
      all_metadata << metadata
    end

    expect(predecessors).to eq([nil, a, b])
    expect(all_metadata).to eq([nil, 'foo', 'bar'])
  end

  def node(value)
    Graph::Node.new(value)
  end
end