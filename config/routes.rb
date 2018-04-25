Rails.application.routes.draw do
  root 'image#index'

  resources :image, param: :image_id do
    collection do
      post :convert
    end
  end

  resources :received_mail do
    collection do
      post :endpoint
    end
  end
end
