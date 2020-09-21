Rails.application.routes.draw do
  get 'book/viewbook_staff'
  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :books

  namespace :students do
    get :dashboard, to: 'dashboard#show'
    get 'books/:id/borrow', to: 'books#borrow', as: :borrow_book
  end

  namespace :staff do
    get :dashboard, to: 'dashboard#show'
    get 'books/:id/borrow', to: 'books#borrow', as: :borrow_book
  end

  root to: 'static#index'
end
