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
role :web, "67.207.148.138"
role :db,  "67.207.148.138", :primary => true

set :runner, "adam"

depend :remote, :gem, "mislav-will_paginate", "~> 2.2"


after "deploy:update_code", "deploy:symlink"
namespace :deploy do
  task :symlink do
    run "ln -nfs #{deploy_to}/#{shared_dir}/rails #{release_path}/vendor/rails"
  end
end