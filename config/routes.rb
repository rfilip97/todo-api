Rails.application.routes.draw do
  resources :todos, only: [:index, :create, :update, :destroy], defaults: { format: :json } do
    collection do
      delete :destroy_completed
    end
  end
end
