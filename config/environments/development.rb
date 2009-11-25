# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false
ActionController::Base.perform_caching               = false

config.action_controller.perform_caching             = false
ActionController::Base.perform_caching               = false


# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

ASSET_HOST = "http://localhost:3000"
HOST = 'http://localhost:3000'
config.action_controller.asset_host = "http://localhost:3000"


config.log_level = :debug


# ActiveRecord
config.active_record.timestamped_migrations = true
config.active_record.logger = Logger.new(STDOUT)

# Allow debugging without starting rails with --debugger
begin
  require "ruby-debug"
  Debugger.start
rescue LoadError, NameError
  $stderr.puts "Error loading ruby-debug.  Debugger support will not be available.  `gem install ruby-debug` to correct this."
end
