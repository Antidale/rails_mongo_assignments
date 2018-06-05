class Zip

  # class method for easy access to the client
  def self.mongo_client
    Mongoid::Clients.default
  end

  # class method for accessing the specific collection for this class
  def self.collection
    self.mongo_client['zips']
  end

  def self.all(prototype = {}, sort={:population => 1}, offset=0, limit=100)
    self.collection.find(prototype).sort(sort).skip(offset).limit(limit)
  end

end
