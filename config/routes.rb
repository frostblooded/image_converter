Rails.application.routes.draw do
  root 'image#index'

  resources :image, param: :image_id do
    collection do
      post :convert
    end
  end
end
