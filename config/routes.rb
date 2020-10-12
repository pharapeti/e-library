Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :books do
    get :return
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

  root to: 'static#index'
end
