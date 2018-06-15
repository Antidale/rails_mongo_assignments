Rails.application.routes.draw do
  get 'photos/:id/show', to: 'photos#show', as: 'photos_show'
end
