MeuRio::Application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :members, :controllers => { :omniauth_callbacks => "omniauth_callbacks", :sessions => "member_sessions" } do
    get 'logout' => 'member_sessions#destroy', :as => :destroy_member_session
    match '/facebook_logout' => 'member_sessions#facebook_logout', :as => :facebook_logout
    match '/google_logout' => 'member_sessions#google_logout', :as => :google_logout
  end

  # Ren: I no longer believe this is necessary?
  # match 'admin_user_root' => 'admin/dashboard#index'

  namespace :admin do
    get 'preview/petition/:id' => "petitions#preview", :as => "preview_petition"
    get 'petition/:id/export' => "petitions#export", :as => "export_petition"
    get 'petition/:id/export' => "petitions#export", :as => "export_petition"
  end

  resources :pages, :controller => 'pages', :only => :show
  match "petition/:custom_path" => "petitions#show", :as => "custom_petition"
  match "petition/:custom_path/share" => "tafs#show", :as => "custom_taf"
  resources :petition_signatures, :only => [:create, :index]
  resources :issues, :only => [:show]
  match "issues/:id/archive" => "issues#archive", :as => "issue_archive"
  match "issues/:id/archive/:page" => "issues#archive", :as => "issue_archive_page"
  resources :debates, :only => [:show] do
    resources :comments, :only => [:index]
  end
  match 'debates/:id/load_comments/:page' => "debates#load_comments"
  resources :personal_stories, :only => [:show]
  resources :members, :only => [ :show, :update ]
  match "issue/:issue_id/personal-stories" => "personal_stories#issue_index", :as => "issue_personal_stories"
  match "issue/:issue_id/personal-stories/:id" => "personal_stories#issue_index", :as => "issue_personal_story"
  resources :comments, :only => [:create] do
    resources :comment_flags, :only => [:create, :destroy], :as => "flags"
  end

  root :to => "pages#show", :id => "index"
end
