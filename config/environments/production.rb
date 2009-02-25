# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true
config.cache_store = :mem_cache_store, 'localhost:11211'

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
ActionController::Base.perform_caching               = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

#RAILS_ROOT = "/home/arcadefly/alpha.arcadefly.com/current"



ASSET_HOST = "http://static.arcadefly.com"
HOST = "http://www.arcadefly.com"
config.action_controller.asset_host = "http://www.arcadefly.com"


require 'hodel_3000_compliant_logger'
config.logger = Hodel3000CompliantLogger.new(config.log_path)
