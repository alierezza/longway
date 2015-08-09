Rails.application.routes.draw do

  devise_for :users
  root "home#index"

  resources :homes,:reports,:detailreports,:lines,:users,:boards,:problems

end
