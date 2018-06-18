class Racer
  include Mongoid::Document
  embeds_one :racer_info, as :locatable, class RacerInfo
end
