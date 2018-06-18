class Entrant
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in collection: :results
  field :bib, type: Integer
  field :secs, type: Float
  field :o, as: :overall, type: Placing
  field :gender, type: Placing
  field :group, type: Placing
end
