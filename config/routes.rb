Telephone::Application.routes.draw do
  get "welcome/index"
  
  devise_for :admins
  devise_for :users, :registrations => "users", :controllers => {:passwords => "passwords"}
  resources :users, :only => [:new, :create, :show]
  match 'homepage', :to => "homepage#index"
  root :to => "welcome#index"
end
