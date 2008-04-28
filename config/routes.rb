ActionController::Routing::Routes.draw do |map|

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
  map.signup '/signup',   :controller => 'users',    :action => 'new'
  map.login  '/login',    :controller => 'sessions', :action => 'new'
  map.logout '/logout',   :controller => 'sessions', :action => 'destroy'
  map.address '/address', :controller => 'sessions', :action => 'address', :method => 'post'

  # User account controls
  map.activate '/activate/:id',              :controller => 'users',   :action => 'activate'
  map.forgot_password '/forgot_password',    :controller => 'passwords', :action => 'new'
  map.reset_password  '/reset_password/:id', :controller => 'passwords', :action => 'edit'
  map.user_settings '/users/:id/settings',        :controller => 'users', :action => 'edit'

  # Shortened routes
  map.about '/about',       :controller => 'home',    :action => 'about'
  map.contact  '/contact',  :controller => 'home',    :action => 'contact'
  map.terms '/terms',       :controller => 'home',    :action => 'terms'
  map.privacy '/privacy',   :controller => 'home',    :action => 'privacy'
  map.welcome '/welcome',   :controller => 'users',    :action => 'welcome'
  map.help '/help',         :controller => 'help',    :action => 'index'

  # Popular 
  map.popular '/popular',                   :controller => 'popular',    :action => 'index'
  map.popular_arcades '/popular/arcades',   :controller => 'popular',    :action => 'arcades'
  map.popular_games '/popular/games',       :controller => 'popular',    :action => 'games'

  # Better named arcade routes
  map.arcades '/arcades',                             :controller => 'arcades', :action => 'browse'
  map.arcades_distance '/arcades/distace',            :controller => 'arcades', :action => 'distance'
  map.arcades_map '/arcades/map',                     :controller => 'arcades', :action => 'list_map'
  map.arcade_map '/arcades/:id/map',                  :controller => 'arcades', :action => 'map'
  map.new_arcade_1 '/arcades/new/details',            :controller => 'arcades', :action => 'new1'
  map.new_arcade_2 '/arcades/new/verifydetails',      :controller => 'arcades', :action => 'new2'
  map.new_arcade_3 '/arcades/new/addgames',           :controller => 'arcades', :action => 'new3'
  map.new_arcade_2 '/arcades/new/verify',             :controller => 'arcades', :action => 'new4'
  
  # Arcade maps
  map.game_arcades_map '/games/:game_id/arcades/map', :controller => 'arcades', :action => 'list_map'
  map.user_arcades_map '/users/:user_id/arcades/map', :controller => 'arcades', :action => 'list_map'
  
  # Browse for arcades
  map.countries_arcades '/arcades/countries',         :controller => 'arcades', :action => 'countries'
  map.country_arcades '/arcades/countries/:id',       :controller => 'arcades', :action => 'country'
  map.regions_arcades '/arcades/regions',             :controller => 'arcades', :action => 'regions'
  map.region_arcades '/arcades/regions/:id',          :controller => 'arcades', :action => 'region'
  
  # Remote procedures
  map.games_update '/games/update', :controller => 'gateway', :action => 'update_games'
  
  # Resources
  map.resources :arcades, :has_many => [ :games, :users, :favorites ],
                          :has_one => :address
  map.resources :games,   :has_many => [ :arcades, :users, :favorites ]
  map.resources :users,   :has_many => [ :arcades, :games, :friends ],
                          :has_one => :address

  map.resources :users, :alias => :friends
  
  map.resources :addresses, :sessions, :passwords, :favorites

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action.:format'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller', :action => 'index'
end 