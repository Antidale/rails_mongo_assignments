class Photo
  attr_accessor :id, :location
  attr_writer :contents

  def initialize params = {}
    @id = params[:_id].nil? ? nil : params[:_id].to_s

    unless params[:metadata].nil?
      @location = Point.new(params[:metadata][:location])
      @place = params[:metadata][:place]
    end
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

  def self.find_photos_for_place id
    id = BSON::ObjectId.from_string(id) if id.is_a? String
    self.collection.find("metadata.place" => id)
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
    if persisted?
      self.class.collection.find(:_id => BSON::ObjectId.from_string(@id)).update_one(:$set => {:metadata => {
        :location => @location.to_hash,
        :place => @place
      }})
    else #New record
      coords = EXIFR::JPEG.new(@contents).gps
      @location = Point.new(:lat => coords.latitude, :lng => coords.longitude)
      @contents.rewind
      description = {
        :content_type => "image/jpeg",
        :metadata => {
          :location => @location.to_hash
        }
      }
      file = Mongo::Grid::File.new(@contents.read, description)
      @contents.rewind
      @id = self.class.collection.insert_one(file).to_s
    end
  end

  def destroy
    self.class.collection.find(:_id => BSON::ObjectId.from_string(@id)).delete_one
  end

  def find_nearest_place_id max_distance
    result = Place.near(@location, max_distance).limit(1).projection(:_id => 1).first
    result ? result[:_id] : nil
  end

  def place
    @place.presence ? Place.find(@place) : nil
  end

  def place=(value)
    @place = value if value.is_a? BSON::ObjectId
    @place = BSON::ObjectId.from_string(value) if value.is_a? String
    @place = BSON::ObjectId.from_string(value.id) if value.is_a? Place
  end


end
