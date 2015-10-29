Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  # devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  namespace :admin do
    resources :users do
      # collection do
      #   get 'all_users_data_points'
      # end

      resources :mobility_user_interface
      resources :pam_data_points
      resources :mobility_data_points
      resources :ohmage_data_points
      resources :calendar_data_points, :format => :json
      resources :mobility_daily_summary_data_points
      resources :fitbit_data_points
      resources :log_in_data_points
      resources :annotations
    end
    mount Rack::GridFS::Endpoint.new(:db => Mongoid::Config.sessions[:default], :fs_name => 'fs.files', :username => ENV['APP_DB_USERNAME'] || Rails.application.secrets.APP_DB_USERNAME, :password => ENV['APP_DB_PASSWORD'] || Rails.application.secrets.APP_DB_PASSWORD), :at => "gridfs"
  end




  # resources :mobility_dashboard, only: :index
  # resources :inbox, :controller => 'inbox', :only => [:show, :create]

  # namespace :users do
  #   # resources :pam_data_points
  #   # resources :mobility_data_points
  #   # resources :ohmage_data_points
  #   # resources :calendar_data_points, :format => :json

  # end



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
