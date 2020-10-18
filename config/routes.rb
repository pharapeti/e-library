Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

  resources :books do
    get :return
    get :renew
    post :activate, on: :member
    post :deactivate, on: :member
  end

  resources :book_requests do
    post :fulfill, on: :member
  end

  namespace :students do
    get :dashboard, to: 'dashboard#show'
    get 'books/:id/borrow', to: 'books#borrow', as: :borrow_book
    get 'books/:id/pay', to: 'fines#pay', as: :pay_fine
  end

  namespace :staff do
    get :dashboard, to: 'dashboard#show'
    get 'books/:id/borrow', to: 'books#borrow', as: :borrow_book
    get 'books/:id/pay', to: 'fines#pay', as: :pay_fine
  end

  namespace :library_managers do
    get :dashboard, to: 'dashboard#show'
  end

  root to: 'static#index'
end
