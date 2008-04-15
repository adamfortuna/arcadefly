ActionController::Routing::Routes.draw do |map|
  map.resources :roles

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "home"

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # Custom Routes
  map.signup '/signup', :controller => 'users',   :action => 'new'
  map.login  '/login',  :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'

  # User account controls
  map.activate '/activate/:id', :controller => 'user',   :action => 'activate'
  map.forgot_password '/forgot_password',    :controller => 'passwords', :action => 'new'
  map.reset_password  '/reset_password/:id', :controller => 'passwords', :action => 'edit'
  map.settings '/users/:id/settings', :controller => 'users', :action => 'edit'

  # Shortened routes
  map.about '/about',       :controller => 'home',    :action => 'about'
  map.contact  '/contact',  :controller => 'home',    :action => 'contact'
  map.terms '/terms',       :controller => 'home',    :action => 'terms'
  map.privacy '/privacy',   :controller => 'home',    :action => 'privacy'
  map.welcome '/welcome',   :controller => 'user',    :action => 'welcome'

  # Popular 
  map.popular '/popular',                   :controller => 'popular',    :action => 'index'
  map.popular_arcades '/popular/arcades',   :controller => 'popular',    :action => 'arcades'
  map.popular_games '/popular/games',       :controller => 'popular',    :action => 'games'

  # Better named arcade routes
  map.arcades_map '/arcades/map',  :controller => 'arcades',  :action => 'list_map'
  map.arcade_map '/arcades/:id/map', :controller => 'arcades', :action => 'map'
  map.game_arcades_map '/games/:game_id/arcades/map', :controller => 'arcades', :action => 'list_map'
  
  # Arcade/Game/User interaction routes
  map.arcade_favorite '/arcades/:id/favorite', :controller => 'arcades', :action => 'favorite'
  map.game_favorite '/games/:id/favorite',     :controller => 'games',   :action => 'favorite'
  
  # Remote procedures
  map.games_update '/games/update', :controller => 'gateway', :action => 'update_games'
    
  # Resources
  map.resources :arcades, :has_many => [ :games, :users ],
                          :has_one => :address
  map.resources :games,   :has_many => [ :arcades, :users ]
  map.resources :users,   :has_many => [ :arcades, :games, :roles ],
                          :has_one => :address
  
  map.resources :addresses, :sessions, :passwords

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action.:format'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller', :action => 'index'
end 