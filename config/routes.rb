Rails.application.routes.draw do

  devise_for :users
  namespace :api do
    post 'v1/register', to: 'v1#register'
    get 'v1/find_nearby', to: 'v1#find_nearby'
  end

end
