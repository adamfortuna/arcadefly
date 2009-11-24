set :application, "arcadefly"
default_run_options[:pty] = true
set :repository, 'git@github.com:adamfortuna/arcadefly.git'
set(:branch)        { Capistrano::CLI.ui.ask("Deploy from branch: ") }
set :use_sudo,    true
set :user,        "adam"
set :scm,         "git"
#set :git_enable_submodules, 0
set :scm_passphrase, "PaSSph4se" #This is your custom users password
set :deploy_via, :remote_cache



# Dependencies
depend :local,  :command, 'git'


# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"
# set :deploy_to,   "/mnt/app/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "67.207.148.138"
role :web, "67.207.148.138", :asset_host_syncher => true
role :db,  "67.207.148.138", :primary => true

set :runner, "adam"

depend :remote, :gem, "mislav-will_paginate", "~> 2.2"


#after "deploy:update_code", "deploy:rails_symlink"
before "deploy:symlink", "s3_asset_host:synch_public"
after "deploy:update_code", "s3_asset_host:synch_public"
after "deploy:update_code", "deploy:build_assets"
namespace :deploy do

  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

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