module Api
  class RacesController < ApplicationController
    protect_from_forgery with: :null_session

    def index
      if !request.accept || request.accept == "*/*"
        render plain: "/api/races, offset=[#{params[:offset]}], limit=[#{params[:limit]}]"
      else

      end
    end

    def show
      if !request.accept || request.accept == "*/*"
        render plain: "/api/races/#{params[:id]}"
      else

      end
    end

    def results
      if !request.accept || request.accept == "*/*"
        render plain: "/api/races/#{params[:race_id]}/results"
      else

      end
    end

    def racer_results
      if !request.accept || request.accept == "*/*"
        render plain: "/api/races/#{params[:race_id]}/results/#{params[:id]}"
      else

      end
    end

    def create
      if !request.accept || request.accept == "*/*"
        render plain: params[:race][:name], status: :ok
      else
        @race = Race.create(race_params)
        render plain: @race.name, status: :created
      end
    end

    def create_result
      params.each {|pk, pv| puts "#{pk} => #{pv}"}
      if !request.accept || request.accept == "*/*"
        render plain: :nothing, status: :ok
      else

      end
    end

    private
      def race_params
        params.require(:race).permit(:name, :date)
      end
  end
end
