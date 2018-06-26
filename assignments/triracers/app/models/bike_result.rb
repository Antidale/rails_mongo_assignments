class BikeResult < LegResult
  field :mph, type: Float
  @@secs_per_hour = 3600
  def calc_ave
    if event && secs
      miles = event.miles
      self.mph = miles.nil? ? nil : miles * @@secs_per_hour / secs
    end
  end
end
