class Point
  attr_accessor :longitude, :latitude

  def initialize hash = {}
    @latitude = hash[:lat].nil? ? hash[:coordinates][1] : hash[:lat]
    @longitude = hash[:lng].nil? ? hash[:coordinates][0] : hash[:lng]
  end

  def to_hash
    { type: self.class.name, coordinates: [@longitude, @latitude]}
  end
end
