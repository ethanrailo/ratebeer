Rails.application.routes.draw do
  resources :styles
  resources :memberships
  resources :beer_clubs
  resources :users do
    post "toggle_account_status", on: :member
  end
  resources :beers
  resources :breweries do
    post "toggle_activity", on: :member
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "breweries#index"
  get "kaikki_bisset", to: "beers#index"
  # get "ratings", to: "ratings#index"
  # get "ratings/new", to: "ratings#new"
  # post "ratings", to: "ratings#create"
  resources :ratings, only: [:index, :new, :create, :destroy]
  get "signup", to: "users#new"
  resource :session, only: [:new, :create, :destroy]
  get "signin", to: "sessions#new"
  delete "signout", to: "sessions#destroy"
  resources :places, only: [:index, :show]
  post "places", to: "places#search"
  get "beerlist", to: "beers#list"
  get "brewerylist", to: "breweries#list"
end
