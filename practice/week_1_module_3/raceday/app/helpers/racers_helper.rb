module RacersHelper

  def toRacer(value)
    value.is_a?(Racer) ? value : Racer.new(value)
  end
end
