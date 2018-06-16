class Place
  include ActiveModel::Model
  attr_accessor :id, :formatted_address, :location, :address_components

  def initialize params
    @id = params[:_id].to_s
    @location = Point.new params[:geometry][:geolocation]

    @address_components = params[:address_components].nil? ? [] :
      params[:address_components].collect { |ac| AddressComponent.new(ac)}
    @formatted_address = params[:formatted_address]
  end

  def self.mongo_client
    Mongoid::Clients.default
  end

  def self.collection
    self.mongo_client[:places]
  end

  def self.load_all file
    self.collection.insert_many(JSON.parse(File.read(file)))
  end

  def self.find_by_short_name short_name
    self.collection.find("address_components.short_name" => short_name)
  end

  def self.to_places input
    input.collect { |i| Place.new i }
  end

  def self.find id
    result = self.collection.find(_id: BSON::ObjectId.from_string(id)).first
    result.nil? ? nil : Place.new(result)
  end

  def self.all offset = 0, limit = 0
    self.collection.find.skip(offset).limit(limit).collect { |p| Place.new p }
  end

  def self.get_address_components sort = nil, offset = nil, limit = nil
    agg = self.collection.find.aggregate([
      { :$unwind => "$address_components" },
      { :$project =>
        { :_id => 1,
          :address_components => 1,
          :formatted_address => 1,
          "geometry.geolocation" => 1 }
      }])

    agg.pipeline << {:$sort => sort} if sort
    agg.pipeline << {:$skip => offset} if offset
    agg.pipeline << {:$limit => limit} if limit
    agg
  end

  def self.get_country_names
    self.collection.find.aggregate([
      {:$unwind => "$address_components"},
      {:$unwind => "$address_components.types"},
      {:$project => {
        :_id => false,
        :types => "$address_components.types",
        :long_name => "$address_components.long_name"}
      },
      {:$match => {"types" => 'country'}},
      {:$group => { :_id =>  "$long_name"}}
    ]).collect{ |doc| doc[:_id] }
  end

  def self.find_ids_by_country_code country_code
    self.collection.find.aggregate([
      {:$match => {"address_components.short_name" => country_code}},
      {:$project => {:_id => true}}
    ]).collect{ | doc | doc[:_id].to_s}
  end

  def self.create_indexes
    self.collection.indexes.create_one({"geometry.geolocation" => Mongo::Index::GEO2DSPHERE})
  end

  def self.remove_indexes
    self.collection.indexes.drop_one("geometry.geolocation_2dsphere")
  end

  def self.near point, max_meters = 0
    near = {:$geometry => point.to_hash}
    near[:$maxDistance] = max_meters unless max_meters == 0

    self.collection.find("geometry.geolocation" => {
      :$near => near
    })
  end

  def photos offset = 0, limit = 0
    Photo.find_photos_for_place(@id).skip(offset).limit(limit).collect { |p| Photo.new(p)}
  end

  def near max_meters = 0
    self.class.to_places (self.class.near @location, max_meters)
  end

  def destroy
    self.class.collection.delete_one(_id: BSON::ObjectId.from_string(@id))
  end

  def persisted?
    !@id.nil?
  end

end
