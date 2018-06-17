class Address
  attr_accessor :city, :state, :location

  def initialize city, state, location
    @city = city
    @state = state
    @location = location

  end

  def mongoize
    {:city => @city, :state => @state, :loc => @location.mongoize}
  end



  def self.mongoize obj
    case obj
    when Hash then obj
    when Address then obj.mongoize
    else nil
    end
  end

  def self.demongoize obj
    case obj
    when Address then obj
    when Hash then Address.new(obj[:city], obj[:state], Point.demongoize(obj[:loc]))
    end
  end

  def self.evolve obj
    case obj
    when Hash then obj
    when Address then obj.mongoize
    else nil
    end
  end
end
