module Graph
  # a node in a graph, implemented as an adjacency list
  class Node
    attr_reader :value
    attr_reader :neighbors_with_metadata

    def initialize(value)
      @value = value
      @neighbors_with_metadata = {}
    end

    def add_neighbor(other_node, metadata=nil)
      @neighbors_with_metadata[other_node.value] = NeighborWithMetadata.new(other_node, metadata)
    end

    # shorthand to get just the neighboring nodes, without the extra info
    def neighbors
      @neighbors_with_metadata.values.map(&:node)
    end

    def metadata_for(neighbor)
      @neighbors_with_metadata[neighbor.value].metadata
    end

    class NeighborWithMetadata
      attr_reader :node, :metadata
      def initialize(node, metadata)
        @node = node
        @metadata = metadata
      end
    end

    def to_s
      @value.to_s
    end
  end
end