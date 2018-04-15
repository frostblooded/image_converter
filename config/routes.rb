Rails.application.routes.draw do
  root 'image#index'

  resources :image, param: :file_name do
    collection do
      post :convert
    end
  end
end
