set :application, "arcadefly"
set :repository,  "http://svn.arcadefly.com/trunk"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "67.207.148.138"
role :web, "67.207.148.138", :asset_host_syncher => true
role :db,  "67.207.148.138", :primary => true

set :runner, "adam"

depend :remote, :gem, "mislav-will_paginate", "~> 2.2"


after "deploy:update_code", "deploy:rails_symlink"
after "deploy:update_code", "deploy:build_assets"
namespace :deploy do
  task :rails_symlink do
    run "ln -nfs #{deploy_to}/#{shared_dir}/rails #{release_path}/vendor/rails"
  end
  
  desc "Create asset packages for production" 
  task :build_assets do
    run <<-EOF
      cd #{release_path} && rake RAILS_ENV=production asset:packager:build_all
    EOF
  end
  
end


before "deploy:symlink", "s3_asset_host:synch_public"