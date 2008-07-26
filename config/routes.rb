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
  map.signin '/signin',   :controller => 'sessions', :action => 'new'
  map.logout '/logout',   :controller => 'sessions', :action => 'destroy'
  map.address '/address', :controller => 'sessions', :action => 'address', :method => 'post'

  # User account controls
  map.activate '/activate/:id',              :controller => 'users',   :action => 'activate'
  map.forgot_password '/forgot_password',    :controller => 'password', :action => 'new'
  map.reset_password  '/reset_password/:id', :controller => 'password', :action => 'edit'

  # Shortened routes
  map.about '/about',           :controller => 'home',    :action => 'about'
  map.contact  '/contact',      :controller => 'home',    :action => 'contact'
  map.terms '/terms',           :controller => 'home',    :action => 'terms'
  map.privacy '/privacy',       :controller => 'home',    :action => 'privacy'
  map.welcome '/welcome',       :controller => 'users',   :action => 'welcome'
  map.help '/help',             :controller => 'help',    :action => 'index'
  map.features '/features',     :controller => 'help',    :action => 'features'
  map.site_map '/site_map',     :controller => 'home',    :action => 'site_map'

  # Popular 
  map.popular '/popular',                   :controller => 'popular',    :action => 'index'

  # Better named arcade routes
  map.browse_arcades '/arcades/browse',               :controller => 'arcades', :action => 'browse'
  #map.new_arcade_1 '/arcades/new/details',            :controller => 'arcades', :action => 'new1'
  #map.new_arcade_2 '/arcades/new/review',             :controller => 'arcades', :action => 'new2'
  #map.new_arcade_3 '/arcades/new/games',              :controller => 'arcades', :action => 'new3'
  map.edit_arcade_games '/arcades/:id/games/edit',    :controller => 'arcades', :action => 'edit_games'
  
  # Arcade maps
  #map.game_arcades '/games/:game_id/arcades', :controller => 'arcades', :action => 'list_map'
  #map.profile_arcades '/users/:user_id/arcades', :controller => 'arcades', :action => 'list_map'
  
  # Browse for arcades
  #map.countries_arcades '/arcades/countries',         :controller => 'arcades', :action => 'countries'
  #map.country_arcades '/arcades/countries/:id',       :controller => 'arcades', :action => 'country'
  #map.regions_arcades '/arcades/regions',             :controller => 'arcades', :action => 'regions'
  #map.region_arcades '/arcades/regions/:id',          :controller => 'arcades', :action => 'region'
  
  # Remote procedures
  map.games_update '/games/update', :controller => 'gateway', :action => 'update_games'
  
  # Resources
  map.resources :arcades, :has_many    => [ :games, :profiles ],
                          :has_one     => :address,
                          :collection  => [ :popular ],
                          :member      => [ :map, :claim, :favorite, :unfavorite ]

  map.resources :games,   :has_many    => [ :arcades, :profiles ],
                          :collection  => [ :popular ],
                          :member      => [ :favorite, :unfavorite ]

  map.resources :profiles, :has_many   => [:friends, :comments, :messages, :arcades, :games],
                           :has_one    => :address,
                           :collection =>{:search=>:get}

  map.resources :users,   :alias => :friends
  map.resources :addresses, :sessions, :password, :comments, :messages
  map.resources :sessions, :object => [ :address ]


  # Since a lot of people tend to use /login as the login path, add it here just in case.
  map.connect '/login',    :controller => 'redirect', :action => 'login'

  # Install the default routes as the lowest priority.
  map.connect 'help/:action', :controller => 'help'

  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action.:format'
  # map.connect ':controller/:action/:id.:format'
  # map.connect ':controller', :action => 'index'
end 