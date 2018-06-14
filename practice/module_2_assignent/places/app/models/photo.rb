class Photo
  attr_accessor :id, :location
  attr_writer :contents

  def initialize params = {}
    @id = params[:_id].nil? ? nil : params[:_id].to_s

    @location = params[:metadata].nil? ? nil : Point.new(params[:metadata][:location])
  end

  def self.mongo_client
    Mongoid::Clients.default
  end

  def self.collection
    self.mongo_client.database.fs
  end

  def persisted?
    !@id.nil?
  end

  def save
    return if persisted?
    coords = EXIFR::JPEG.new(@contents).gps
    @location = Point.new(:lat => coords.latitude, :lng => coords.longitude)
    @contents.rewind
    description = {
      :content_type => "image/jpeg",
      :metadata => {:location => @location.to_hash }
    }
    file = Mongo::Grid::File.new(@contents.read, description)
    @contents.rewind
    @id = self.class.collection.insert_one(file).to_s

  end


end
