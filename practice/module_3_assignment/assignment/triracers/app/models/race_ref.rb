class RaceRef
  include Mongoid::Document
  field :n, type: String
  field :date, type: Date
end
