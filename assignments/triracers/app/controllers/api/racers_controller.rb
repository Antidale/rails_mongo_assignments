module Api
  class RacersController < ApplicationController

    def index
      if !request.accept || request.accept == "*/*"
        render plain: "/api/racers"
      else

      end
    end

    def show
      if !request.accept || request.accept == "*/*"
        render plain: "/api/racers/#{params[:id]}"
      else

      end
    end

    def entries
      if !request.accept || request.accept == "*/*"
        render plain: "/api/racers/#{params[:racer_id]}/entries"
      else

      end
    end

    def race_entry
      if !request.accept || request.accept == "*/*"
        render plain: "/api/racers/#{params[:racer_id]}/entries/#{params[:id]}"
      else

      end
    end
  end
end
