class Stop
  attr_reader :id, :name
  attr_accessor :subways # TODO: make stops readonly and hydrate at initialization
  attr_accessor :next_stop, :previous_stop

  def initialize(params = {})
    params = params.with_indifferent_access
    @id = params[:id]
    @name = params[:name]
    @subways = []
    @next_stop = nil
    @previous_stop = nil
  end

  # {"attributes"=>
  # {"address"=>nil, 
  # "at_street"=>nil,
  # "description"=>"Saint Paul Street - Green Line - Park Street & North", 
  # "latitude"=>42.343118, 
  # "location_type"=>0, 
  # "longitude"=>-71.117498,
  # "municipality"=>"Brookline",
  # "name"=>"Saint Paul Street",
  # "on_street"=>nil,
  # "platform_code"=>nil,
  # "platform_name"=>"Park Street & North",
  # "vehicle_type"=>0,
  # "wheelchair_boarding"=>2},
  # "id"=>"70218", 
  # "links"=>{"self"=>"/stops/70218"}, 
  # "relationships"=>
  #   {"facilities"=>
  #      {"links"=>{"related"=>"/facilities/?filter[stop]=70218"}}, "parent_station"=>{"data"=>{"id"=>"place-stpul", "type"=>"stop"}}, "zone"=>{"data"=>{"id"=>"RapidTransit", "type"=>"zone"}}}, "type"=>"stop"}
  def self.from_parsed_json(hash)
    raise "Unexpected type #{hash['type']}" unless hash['type'] == 'stop'
    attributes = hash['attributes']
    
    Stop.new(
      :id => hash['id'],
      :name => attributes['name']
    )
  end

  def to_s
    @name
  end

  def ==(other)
    other.is_a?(Stop) && other.id == @id
  end

  def subway_count
    @subways.size
  end
end