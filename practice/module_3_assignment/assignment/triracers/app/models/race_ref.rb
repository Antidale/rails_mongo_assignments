class RaceRef
  include Mongoid::Document
  field :n, as: :name, type: String
  field :date, type: Date
end
