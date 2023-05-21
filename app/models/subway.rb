class Subway
  attr_reader :id, :long_name
  attr_accessor :stops # TODO: make stops readonly and hydrate at initialization

  def initialize(params = {})
    params = params.with_indifferent_access
    @id = params[:id]
    @long_name = params[:long_name]
    @stops = []
  end

  def stop_count
    @stops.size
  end

  def stop_ids
    @stop_ids ||= @stops.map(&:id)
  end

  # Sample expected response:
  # {
  #  "attributes"=> {
  #    ...
  #    "long_name"=>"Blue Line", 
  #    ...
  #  }, 
  #  "id"=>"Blue",
  #  ...
  #  "relationships"=>{ ... }, 
  #  "type"=>"route"
  # }
  def self.from_parsed_json(hash)
    raise "Unexpected type #{hash['type']}" unless hash['type'] == 'route'

    attributes = hash['attributes']
    
    Subway.new(
      :id => hash['id'],
      :long_name => attributes['long_name']
    )
  end

  def to_s
    @long_name
  end

  def ==(other)
    other.is_a?(Subway) && other.id == @id
  end
end