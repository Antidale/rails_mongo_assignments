class Zip

  # class method for easy access to the client
  def self.mongo_client
    Mongoid::Clients.default
  end

  # class method for accessing the specific collection for this class
  def self.collection
    self.mongo_client['zips']
  end

end
