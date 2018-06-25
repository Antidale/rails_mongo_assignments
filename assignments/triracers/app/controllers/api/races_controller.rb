module Api
  class RacesController < ApplicationController
    protect_from_forgery with: :null_session
    before_action :set_race, only: [:update, :destroy]
    before_action :set_entrant, only: [:update_racer_result]

    rescue_from Mongoid::Errors::DocumentNotFound do | exception |
      if !request.accept || request.accept == "*/*"
        render plain: "whoops: cannot find race[#{params[:id]}]", status: :not_found
      else
        respond_to do |format |
          format.json {render status: :not_found, template: "api/error", locals: {msg: "woops: cannot find race[#{params[:id]}]"} }
          format.xml {render status: :not_found, template: "api/error", locals: {msg: "woops: cannot find race[#{params[:id]}]"}}
        end
      end
    end

    rescue_from ActionView::MissingTemplate do |exception|
      Rails.logger.debug exception
      render plain: "woops: we do not support that content-type[#{request.accept}]", status: :unsupported_media_type
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
        set_race
        render @race, content_type: "#{request.accept}"
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
        @race = set_race
        @entrants = @race.entrants
        last_modified = @entrants.max(:updated_at)
        if stale?(last_modified: last_modified)
          fresh_when last_modified: last_modified
          render json: @entrants
        end
      end
    end

    def racer_results
      if !request.accept || request.accept == "*/*"
        render plain: "/api/races/#{params[:race_id]}/results/#{params[:id]}"
      else
        set_race
        set_entrant
        render :partial => 'result', :object => @result
      end
    end

    def create
      if !request.accept || request.accept == "*/*"
        if params[:race]
          render plain: params[:race][:name], status: :ok
        end
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

    #patch /api/races/{race_id}/results/{entrant_id}
    def update_racer_result
      result = params[:result]
      if result
        if result[:swim]
          @result.swim = @result.race.race.swim
          @result.swim_secs = result[:swim].to_f
        end
        if result[:t1]
          @result.t1 = @result.race.race.t1
          @result.t1_secs = result[:t1].to_f
        end
        if result[:bike]
          @result.bike = @result.race.race.bike
          @result.bike_secs = result[:bike].to_f
        end
        if result[:t2]
          @result.t2 = @result.race.race.t2
          @result.t2_secs = result[:t2].to_f
        end
        if result[:run]
          @result.run = @result.race.race.run
          @result.run_secs = result[:run].to_f
        end
        @result.save
      end
      render json: @result
    end

    private
      def race_params
        params.require(:race).permit(:name, :date)
      end

      def set_race
        @race = params[:id] ? Race.find(params[:id]) : Race.find(params[:race_id])
      end

      def set_entrant
        @result = Race.find(params[:race_id]).entrants.where(:id => params[:id]).first
      end
  end
end
