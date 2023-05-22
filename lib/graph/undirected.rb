# Inspired by: https://medium.com/@young.scottw/implementing-an-undirected-graph-in-ruby-c11258b3d95b
module Graph

  # undirected graph, every edge is bidirectional
  class Undirected
    def initialize
      @nodes = {}
    end

    def add_node(node)
      @nodes[node.value] ||= node
    end

    def get_node(value)
      @nodes[value]
    end

    # Add an edge between the nodes with the given values, optionally providing
    # extra info (ie: weight, metadata) to be associated with the edge.
    def add_edge(value1, value2, metadata=nil)
      @nodes[value1].add_neighbor(@nodes[value2], metadata)
      @nodes[value2].add_neighbor(@nodes[value1], metadata)
    end
  end
end