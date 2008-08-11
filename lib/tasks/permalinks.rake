namespace :permalink do

  desc "Update games.permalink"  
  task :games => :environment do
    games = Game.find(:all)
    
    games.each do |game|
      game.permalink = nil
      game.save
    end
  end
end