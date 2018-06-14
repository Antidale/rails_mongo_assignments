class AddressComponent
  attr_reader :long_name, :short_name, :types

  def initialize hash = {}
    @long_name = hash[:long_name]
    @short_name = hash[:short_name]
    @types = hash[:types]
  end
end
