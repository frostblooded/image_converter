Rails.application.routes.draw do
  root 'image#index'

  resources :image do
    collection do
      post :convert
    end
  end
end
