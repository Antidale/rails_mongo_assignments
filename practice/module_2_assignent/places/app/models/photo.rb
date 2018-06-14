class Photo
  attr_accessor :id, :location
  attr_writer :contents


  def self.mongo_client
    Mongoid::Clients.default
  end

  def initialize params = {}
    @id = params[:_id].nil? ? nil : params[:_id].to_s

    @location = params[:metadata].nil? ? nil : Point.new(params[:metadata][:location])

  end


end
