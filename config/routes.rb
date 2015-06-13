Rails.application.routes.draw do

  devise_for :users
  namespace :api do
    resources :apis do
      post :register
      get :find_nearby
    end
  end

end
