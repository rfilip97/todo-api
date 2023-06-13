Rails.application.routes.draw do
  resources :todos, only: [:index], defaults: { format: :json }
end
