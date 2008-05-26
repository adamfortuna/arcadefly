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
  map.signin '/signin',    :controller => 'sessions', :action => 'new'
  map.logout '/logout',   :controller => 'sessions', :action => 'destroy'
  map.address '/address', :controller => 'sessions', :action => 'address', :method => 'post'

  # User account controls
  map.activate '/activate/:id',              :controller => 'users',   :action => 'activate'
  map.forgot_password '/forgot_password',    :controller => 'passwords', :action => 'new'
  map.reset_password  '/reset_password/:id', :controller => 'passwords', :action => 'edit'
  map.user_settings '/users/:id/settings',   :controller => 'users', :action => 'edit'

  # Shortened routes
  map.about '/about',       :controller => 'home',    :action => 'about'
  map.contact  '/contact',  :controller => 'home',    :action => 'contact'
  map.terms '/terms',       :controller => 'home',    :action => 'terms'
  map.privacy '/privacy',   :controller => 'home',    :action => 'privacy'
  map.welcome '/welcome',   :controller => 'users',   :action => 'welcome'
  map.help '/help',         :controller => 'help',    :action => 'index'

  # Popular 
  map.popular '/popular',                   :controller => 'popular',    :action => 'index'
  map.popular_arcades '/popular/arcades',   :controller => 'popular',    :action => 'arcades'
  map.popular_games '/popular/games',       :controller => 'popular',    :action => 'games'

  # Better named arcade routes
  map.browse_arcades '/arcades/browse',               :controller => 'arcades', :action => 'browse'
  map.arcade_map '/arcades/:id/map',                  :controller => 'arcades', :action => 'map'
  map.new_arcade_1 '/arcades/new/details',            :controller => 'arcades', :action => 'new1'
  map.new_arcade_2 '/arcades/new/review',             :controller => 'arcades', :action => 'new2'
  map.new_arcade_3 '/arcades/new/games',              :controller => 'arcades', :action => 'new3'
  map.edit_arcade_games '/arcades/:id/games/edit',    :controller => 'arcades', :action => 'edit_games'
  
  # Arcade maps
  #map.game_arcades '/games/:game_id/arcades', :controller => 'arcades', :action => 'list_map'
  #map.profile_arcades '/users/:user_id/arcades', :controller => 'arcades', :action => 'list_map'
  
  # Browse for arcades
  #map.countries_arcades '/arcades/countries',         :controller => 'arcades', :action => 'countries'
  map.country_arcades '/arcades/countries/:id',       :controller => 'arcades', :action => 'country'
  #map.regions_arcades '/arcades/regions',             :controller => 'arcades', :action => 'regions'
  map.region_arcades '/arcades/regions/:id',          :controller => 'arcades', :action => 'region'
  
  # Remote procedures
  map.games_update '/games/update', :controller => 'gateway', :action => 'update_games'
  
  # Resources
  map.resources :arcades, :has_many => [ :games, :profiles, :favorites ],
                          :has_one => :address
  map.resources :games,   :has_many => [ :arcades, :profiles, :favorites ]

  map.resources :users,   :alias => :friends
  
  map.resources :addresses, :sessions, :passwords, :favorites



  map.namespace :admin do |a|
    a.resources :users, :collection => {:search => :post}
  end

  map.resources :profiles, 
  :member => {:delete_icon=>:post}, :collection=>{:search=>:get}, 
  :has_many => [:friends, :blogs, :photos, :comments, :feed_items, :messages, :arcades, :games],
  :has_one => :address

  map.resources :messages, :collection => {:sent => :get}
  map.resources :blogs do |blog|
    blog.resources :comments
  end


  # Since a lot of people tend to use /login as the login path, add it here just in case.
  map.connect '/login',    :controller => 'sessions', :action => 'new'

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action.:format'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller', :action => 'index'
end 