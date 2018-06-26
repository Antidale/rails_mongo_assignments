class Placing
  attr_accessor :name, :place

  def initialize name, place
    @name = name
    @place = place
  end

  def mongoize
    {:name => name, :place => place}
  end


  #class methods
  def self.mongoize obj
    case obj
    when Hash then obj
    when Placing then obj.mongoize
    else nil
    end
  end

  def self.demongoize obj
    case obj
    when Hash then Placing.new(obj[:name], obj[:place])
    when Placing then obj
    else nil
    end
  end

  def self.evolve obj
    self.mongoize obj
  end


end
