Rails.application.routes.draw do
  apipie
  get 'home/index'
  devise_for :users
  root 'home#index'

  namespace :api do
    namespace :v1 do
      devise_scope :user do
        post "/sign_in", :to => 'sessions#create'
        post "/sign_up", :to => 'registrations#create'
        delete "/sign_out", :to => 'sessions#destroy'
        # put '/change_password', to: 'registrations#change_password'
        get "/profile", :to => 'registrations#profile'
        post "/update_account", :to => 'registrations#update'
        get '/users', to: 'sessions#index'
        # get "/reset_password", :to => 'registrations#reset_password'
        # get "/reset_password_link", :to => 'registrations#reset_password_link'
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
