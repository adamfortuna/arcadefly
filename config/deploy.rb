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

desc "Create a symlink to the current version of rails"
task :after_update_code, :except => { :no_release => true } do
  run "sudo ln -s #{release_path}/vendor/rails #{shared_dir}/rails"
end