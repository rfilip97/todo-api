Rails.application.routes.draw do
  resources :todos, only: [:index, :create, :update, :destroy], defaults: { format: :json }
end
