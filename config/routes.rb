Rails.application.routes.draw do

  devise_for :users
  match 'api/v1/register' => 'api/user#register_api', via: [:post]
  match 'api/v1/find_nearby' => 'api/user#find_nearby', via: [:get]

  root to: "home#index"
end
