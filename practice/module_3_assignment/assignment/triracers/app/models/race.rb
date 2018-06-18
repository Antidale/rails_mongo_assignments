class Race
  include Mongoid::Document
  include Mongoid::Timestamps
  field :n, as: :name, type: String
  field :date, type: Date
  field :loc, as: :location, type: Address
  embeds_many :events, as: :parent, order: [:order.asc]
end
