# frozen_string_literal: true

Rails.application.routes.draw do
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
  get '/post/:id/comments/:parent_comment_id/comments' => 'comments#create', as: 'post_comments_comments'

  match '*not_found' => 'errors#error_404', via: :all
end
