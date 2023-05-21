module Transit
  class Stop
    attr_reader :id, :name
    attr_accessor :routes

    def initialize(id, name)
      @id = id
      @name = name
      @routes = Set.new
    end
  end
end