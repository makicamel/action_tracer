# frozen_string_literal: true

Rails.application.routes.draw do
  get :orders, to: 'orders#index'
  get :conditions, to: 'conditions#index'
  get :halts, to: 'halts#index'
end
