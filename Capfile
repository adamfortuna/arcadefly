load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy'

namespace :deploy do
  desc "Create a symlink to the current version of rails"
  task :after_update_code, :roles => [:app, :db, :web] do
    run "ln -nfs #{shared_path}/rails #{release_path}/vendor/rails"
  end
end