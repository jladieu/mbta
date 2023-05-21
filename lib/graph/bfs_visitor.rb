module Graph

  # Breadth-first search visitor for a graph.  Allows for an optional callback block which will
  # be called for each node in the graph, in the order they are visited.  Each visit will emit
  # a triplet composed of the node, the predecessor node (or nil if there is none), and any
  # metadata associated with the edge between the node and its predecessor.
  class BfsVisitor
    attr_reader :visitors, :predecessors

    def initialize(&block)
      @visited = Hash.new(false)
      @predecessors = {}
    end

    def self.visit(start_node, &block)
      new.tap do |visitor|
        visitor.visit(start_node, &block)
      end
    end

    # finds the shortest path between two nodes in the graph
    def self.find_path(start_node, end_node, &block)
      # populate the predecessor map so we can traverse backwards from end node
      visitor = visit(start_node, &block)

      path = []
      current_node = end_node

      while current_node && current_node != start_node
        path.prepend(current_node)
        predecessor_node, metadata = visitor.predecessors[current_node]
        current_node = predecessor_node
      end

      # if we followed the predecessor map all the way back to nil, there is no path
      return nil if current_node.nil?

      # TODO: test for edge case if there is no path between the two nodes
      path.prepend(start_node)
      path
    end

    def visit(start_node, &block)
      # reset visit details for each visit
      @visited = Hash.new(false)
      @predecessors = {}

      # queue will be an array of [node, predecessor, metadata] triples
      queue = Queue.new
      # start node has no predecessor
      queue << [start_node, nil, nil]
      @visited[start_node] = true

      until queue.empty?
        current_node, predecessor, metadata = queue.deq
        block.call(current_node, predecessor, metadata) if block_given?

        current_node.neighbors_with_metadata.each_pair do |value, neighbor|
          unless @visited[neighbor.node]
            queue << [neighbor.node, predecessor=current_node, neighbor.metadata]
            @visited[neighbor.node] = true
            @predecessors[neighbor.node] = [predecessor, neighbor.metadata]
          end
        end
      end
    end
  end
end