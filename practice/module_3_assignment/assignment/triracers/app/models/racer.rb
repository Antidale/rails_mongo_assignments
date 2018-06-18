class Racer
  include Mongoid::Document
  embeds_one :info, as: :parent, class_name: 'RacerInfo', autobuild: true


  before_create do |racer|
    racer.info.id = racer.id
  end
end
