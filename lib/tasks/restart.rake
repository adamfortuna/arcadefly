namespace :server do

  desc "Restart the apache server"  
  task :restart do
    system("touch tmp/restart.txt")
    system("touch tmp/debug.txt") if ENV["DEBUG"] == 'true'
  end
end