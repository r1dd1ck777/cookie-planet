Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  namespace :ajax do
    post 'recipe/text_nodes'
    get 'foods/all'
    get 'count_types/all'
    post 'profile/currency'
  end

  scope :my do
    get 'profile' => 'users/profile#index', as: :my_profile
    get 'edit/password' => 'users/profile#edit_password', as: :edit_password
    patch 'edit/password' => 'users/profile#update_password', as: :update_password

    scope :recipes do
      get 'new' => 'recipe#new', as: :recipe_new
      get '' => 'recipe#my_list', as: :recipe_list
      get ':id/edit' => 'recipe#edit', as: :recipe_edit
      post '' => 'recipe#create', as: :recipe_create
      patch ':id' => 'recipe#update', as: :recipe_update
      delete ':id' => 'recipe#delete'

      get 'watched' => 'recipe#watched', as: :watched_recipe_list
      # id here actually is recipe_id
      get 'likes' => 'wanted_recipe#list', as: :wanted_recipe_list
      post 'likes/:id' => 'wanted_recipe#create', as: :wanted_recipe
      delete 'likes/:id' => 'wanted_recipe#delete'
    end
  end

  devise_for :users, :controllers => {
      :omniauth_callbacks => "users/omniauth_callbacks",
      :registrations => "users/registrations",
      :sessions => "users/sessions"

  }, path: "my"

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get 'search' => 'permalink#search', as: :search
  get ':slug' => 'permalink#show1', as: :permalink

  root 'static#landing'
end
