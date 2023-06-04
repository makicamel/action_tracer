# frozen_string_literal: true

Rails.application.routes.draw do
  get :orders, to: 'orders#index'
  get :conditions, to: 'conditions#index'
  get :undefined_methods, to: 'undefined_methods#index'
  get :halts, to: 'halts#index'
  get :redirects, to: 'redirects#index'
  get :exceptions, to: 'exceptions#index'
end
