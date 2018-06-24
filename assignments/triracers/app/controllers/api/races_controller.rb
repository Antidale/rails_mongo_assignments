module Api
  class RacesController < ApplicationController
    protect_from_forgery with: :null_session
    before_action :set_race, only: [:show, :edit, :update, :destroy]

    rescue_from Mongoid::Errors::DocumentNotFound do | exception |
      if !request.accept || request.accept == "*/*"
        render "whoops: cannot find race[#{params[:id]}]", status: :not_found
      else
        render status: :not_found, template: "api/error", locals: {msg: "woops: cannot find race[#{params[:id]}]"}
      end
    end

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
        render "race", content_type: "#{request.accept}"
      end
    end

    def update
      @race.update(race_params)
      render json: @race
    end

    def destroy
      @race.destroy
      render :nothing => true, :status => :no_content
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

      def set_race
        @race = Race.find(params[:id])
      end
  end
end
