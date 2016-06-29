Rails.application.routes.draw do

  resources :settings
  devise_for :users
  root "homes#index"

  resources :homes ,:reports ,:detailreports ,:lines ,:users ,:boards ,:problems, :masteremails, :ads, :images, :articles, :categories, :countries, :defects, :languages
  resources :working_hours, only: [:index, :show]

  resources :working_days  do
  	resources :working_hours, only: [:new, :create, :edit, :update, :destroy]
  end

  resources :header_boards do
  	post :update_row_order, on: :collection
  end

  get "data/" => "reports#data", :as => :data

end
