Rails.application.routes.draw do

  devise_for :users
  match 'api/v1/register' => 'api/v1#register_user', via: [:post]
  match 'api/v1/find_nearby' => 'api/v1#find_nearby', via: [:get]

  root to: "home#index"
end
