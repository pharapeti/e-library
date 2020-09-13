Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  namespace :students do
    get :dashboard, to: 'dashboard#show'
  end

  namespace :staff do
    get :dashboard, to: 'dashboard#show'
    resources :books
  end

  root to: 'static#index'
end
