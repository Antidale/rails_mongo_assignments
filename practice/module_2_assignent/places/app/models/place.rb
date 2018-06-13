class Place
  include ActiveModel::Model

  def initialize

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
end
