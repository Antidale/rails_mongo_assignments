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

  def self.all skip = 0, limit = 0
    self.collection.find.skip(skip).limit(limit).collect { |doc| Photo.new(doc)}
  end

  def self.find id
    doc = self.collection.find(_id: BSON::ObjectId.from_string(id)).first
    doc.nil? ? nil : Photo.new(doc)
  end

  def persisted?
    !@id.nil?
  end

  def contents
    grid_file = self.class.collection.find_one(_id: BSON::ObjectId.from_string(id))

    if grid_file
      buffer = ""
      grid_file.chunks.reduce([]) { | x , chunk | buffer << chunk.data.data }
    end

    return  buffer
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

  def destroy
    self.class.collection.find(:_id => BSON::ObjectId.from_string(@id)).delete_one
  end

  def find_nearest_place max_distance

  end

end
