class LegResult
  include Mongoid::Document
  field :secs, type: Float
  embedded_in :entrant
  embeds_one :event, as: :parent

  def calc_ave

  end

  after_initialize do |doc|
    doc.calc_ave
  end

  def secs=value
    @secs = value
    calc_ave
  end

  def secs
    @secs
  end

  validates :event, presence: true
end
