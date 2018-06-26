class Zip

  attr_accessor :id, :city, :population, :state

  def initialize(params = {})
    @id = params[:id]
    @city = params[:city]
    @population = params[:population].to_i
    @state = params[:state]
  end
  # class method for easy access to the client
  def self.mongo_client
    Mongoid::Clients.default
  end

  # class method for accessing the specific collection for this class
  def self.collection
    self.mongo_client[:zips]
  end

  def self.all(prototype = {}, sort={:population => 1}, offset=0, limit=100)
    self.collection.find(prototype).sort(sort).skip(offset).limit(limit)
  end

  def self.find id
    self.collection.find(_id: id).first
  end

  def insert
    self.class.collection.insert_one(
      _id: @id,
      city: @city,
      population: @popluation,
      state: @state)
  end

end
