# frozen_string_literal: true

Rails.application.routes.draw do
  resources :pricing_rules, except: %i(new)
  get "pricing_rules/:product_id/new", to: "pricing_rules#new", as: :new_pricing_rule
  post "pricing_rules/activate", to: "pricing_rules#activate", as: :activate_pricing_rule
  post "pricing_rules/deactivate", to: "pricing_rules#deactivate", as: :deactivate_pricing_rule
  resources :products

  root "products#index"
end
