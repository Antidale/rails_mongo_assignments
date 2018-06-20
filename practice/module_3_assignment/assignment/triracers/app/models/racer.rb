class Racer
  include Mongoid::Document
  embeds_one :info, as: :parent, class_name: 'RacerInfo', autobuild: true
  has_many :races, class_name: "Entrant", foreign_key: "racer.racer_id", dependent: :nullify, order: :"race.date".desc


  before_create do |racer|
    racer.info.id = racer.id
  end
end
