Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :books do
    get :return
  end

  namespace :students do
    get :dashboard, to: 'dashboard#show'
    get 'books/:id/borrow', to: 'books#borrow', as: :borrow_book
  end

  namespace :staff do
    get :dashboard, to: 'dashboard#show'
    get 'books/:id/borrow', to: 'books#borrow', as: :borrow_book
  end

  namespace :library_managers do
    get :dashboard, to: 'dashboard#show'
  end

  root to: 'static#index'
end
