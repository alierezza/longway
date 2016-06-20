Rails.application.routes.draw do

  devise_for :users
  root "homes#index"

  resources :homes ,:reports ,:detailreports ,:lines ,:users ,:boards ,:problems, :masteremails, :ads, :images, :articles, :categories, :countries, :defects

  resources :header_boards do
  	post :update_row_order, on: :collection
  end

  get "data/" => "reports#data", :as => :data

end
