class RacerInfo
  include Mongoid::Document
  embedded_in :parent, polymorphic: true
  field :racer_id, as: :_id
  field :_id, default:->{racer_id}
  field :fn, as: :first_name, type: String
  field :ln, as: :last_name, type: String
  field :g, as: :gender, type: String
  field :yr, as: :birth_year, type: Integer
  field :res, as: :residence, type: Address

  validates :first_name, :last_name, :gender, :birth_year, presence: true
  validates :gender, inclusion: { in: ['M', 'F'],
    message: "%{value} must be either 'M' or 'F'"}
  validates :birth_year, numericality: { less_than: Date.today.year }
end
