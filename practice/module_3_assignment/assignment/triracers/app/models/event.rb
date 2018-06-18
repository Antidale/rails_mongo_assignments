class Event
  include Mongoid::Document
  field :o, as: :order,  type: Integer
  field :n, as: :name, type: String
  field :d, as: :distance, type: Float
  field :u, as: :units, type: String

  def meters
    case self.units
    when "meters" then self.distance
    when "miles" then self.distance * 1609.344
    when "yards" then self.distance * 0.9144
    when "kilometers" then self.distance * 1000
    else nil
    end
  end

  def miles
    case self.units
    when "meters" then self.distance * 0.000621371
    when "miles" then self.distance
    when "yards" then self.distance * 0.000568182
    when "kilometers" then self.distance * 0.621371
    else nil
    end
  end
end
