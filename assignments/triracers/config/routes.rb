Rails.application.routes.draw do
  resources :racers do
    post "entries" => "racers#create_entry"
  end
  resources :races

  namespace :api do
    resources :races do
      get "results" => "races#results"
      get "results/:id" => "races#racer_results", :as => "result"
      post "results" => "races#create_result"
      patch "results/:id" => "races#update_racer_result"
    end
    resources :racers do
      get "entries" => "racers#entries"
      get "entries/:id" => "racers#race_entry"
    end
  end
end
