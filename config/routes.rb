Rails.application.routes.draw do
  get 'book/viewbook_staff'
  devise_for :users, controllers: { registrations: 'users/registrations' }

  namespace :students do
    get :dashboard, to: 'dashboard#show'
  end

  namespace :staff do
    get :dashboard, to: 'dashboard#show'
  end

  root to: 'static#index'
end
