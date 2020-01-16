Rails.application.routes.draw do
  get 'comments/new'
  root 'static_pages#home'
  get 'home'   => "static_pages#home"
  get 'map'  =>  "static_pages#map"
  get 'password_resets/new'
  get 'password_resets/edit'
  post "likes/:tsumiage_id/create" => "likes#create",   as: 'like'
  delete "likes/:tsumiage_id/destroy" => "likes#destroy", as: 'unlike'
  post "comments/:tsumiage_id/create" => "comments#create",   as: 'comment'
  delete "comments/:tsumiage_id/destroy" => "comments#destroy", as: 'uncomment'
  get "comments/:tsumiage_id/open" => "comments#open",   as: 'open'
  get "comments/:tsumiage_id/close" => "comments#close", as: 'close'
  get    '/login',      to: 'sessions#new'
  post   '/login',      to: 'sessions#create'
  delete '/logout',     to: 'sessions#destroy'
  post   '/easy_login', to: 'sessions#easy_login'
  resources :users do
    member do
      get :analysis
      get :analysis_day
      get :analysis_week
      get :analysis_week_normal
      get :analysis_month
      get :analysis_month_normal
    end
  end
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :tsumiages,           only: [:new, :create, :destroy]
  # resources :relationships,     only: [:create, :destroy]
end
