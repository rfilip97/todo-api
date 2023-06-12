Rails.application.routes.draw do
  resources :todos, only: [:index, :create], defaults: { format: :json }
end
