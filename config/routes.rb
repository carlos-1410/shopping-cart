# frozen_string_literal: true

Rails.application.routes.draw do
  get "cart", to: "cart#show"
  put "cart/:product_id", to: "cart#update", as: :update_cart
  post "cart/add", as: :add_to_cart
  post "cart/remove", as: :remove_from_cart

  resources :pricing_rules, except: %i(new)
  get "pricing_rules/:product_id/new", to: "pricing_rules#new", as: :new_pricing_rule

  resources :products

  root "products#index"
end
