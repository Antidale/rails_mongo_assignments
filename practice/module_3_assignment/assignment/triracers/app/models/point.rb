class Point
  attr_accessor :latitude, :longitude

  def initialize longitude, latitude
    @latitude = latitude
    @longitude = longitude
  end

  def mongoize
    {:type => "Point", :coordinates => [@longitude, @latitude]}
  end



  def self.mongoize obj
    case obj
    when Hash then obj
    when Point then obj.mongoize
    else nil
    end
  end

  def self.demongoize obj
    case obj
    when Point then obj
    when Hash then Point.new(obj[:coordinates][0], obj[:coordinates][1])
    else nil
    end
  end

  def self.evolve obj
    case obj
    when Hash then obj
    when Point then obj.mongoize
    else nil
    end
  end


end
