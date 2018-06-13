class Place
  include ActiveModel::Model
  attr_accessor :id, :formatted_address, :location, :address_components

  def initialize params
    @id = params[:_id].nil? ? params[:id] : params[:_id].to_s
    @location = Point.new params[:geometry][:geolocation]

    @address_components = params[:address_components].collect { |ac| AddressComponent.new(ac)}
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

end
