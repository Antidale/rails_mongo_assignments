class Entrant
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in collection: :results
  embeds_many :results, class_name: 'LegResult'
  field :bib, type: Integer
  field :secs, type: Float
  field :o, as: :overall, type: Placing
  field :gender, type: Placing
  field :group, type: Placing
end
