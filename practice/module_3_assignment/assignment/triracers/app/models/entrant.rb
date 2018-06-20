class Entrant
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in collection: :results
  embeds_many :results, class_name: 'LegResult', after_add: :update_total
  embeds_one :race, class_name: "RaceRef"
  embeds_one :racer, as: :parent, class_name: "RacerInfo"
  field :bib, type: Integer
  field :secs, type: Float
  field :o, as: :overall, type: Placing
  field :gender, type: Placing
  field :group, type: Placing

  def update_total result
    self[:secs] = results.reduce(0) { | total, result| total + result.secs}
  end

  def the_race
    race.race
  end

end
