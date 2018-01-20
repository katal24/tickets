Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  get 'events/index'

  get 'events/new'

  post 'events/'  => 'events#create'

  get 'events/:id', :to => "events#show"
  
  resources :tickets
  resources :events, :only => [:index, :new, :create, :show]
  root :to => "home#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

