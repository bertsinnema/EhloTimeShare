Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      
      #locations
      resources :locations do
        member do
          get 'items', to: 'locations#items'
        end
        member do
          get 'users', to: 'locations#users'
        end
      end
      
      #user_locations
      resources :user_locations
      
      #items
      resources :items
    end
  end

  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
end