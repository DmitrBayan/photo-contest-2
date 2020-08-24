# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      resources :posts
      resources :comments
      resources :likes
    end
  end
  get 'errors/error_404'
  ActiveAdmin.routes(self)
  root 'static_pages#home'
  delete 'logout' => 'session#destroy'
  get '/auth/:provider/callback' => 'session#create'
  resources :users
  resources :posts do
    resources :comments
    resource :likes
  end
  post '/posts/:post_id/comments/:parent_comment_id/comments' => 'comments#create', as: 'post_comments_comments'
  match '*not_found' => 'errors#error_404', via: :all
end
