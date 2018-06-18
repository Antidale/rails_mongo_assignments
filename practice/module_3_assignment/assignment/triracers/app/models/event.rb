class Event
  include Mongoid::Document
  field :o, type: Integer
  field :n, type: String
  field :d, type: Float
  field :u, type: String
end
