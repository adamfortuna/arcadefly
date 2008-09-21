namespace :counts do
  
  namespace :games do
    desc "Update games.favoriteships_count"
    task :favoriteships_count => :environment do
      Game.update_all 'favoriteships_count=0'
      Game.find(:all, :include => :favoriteships, :conditions => 'favoriteships.id IS NOT NULL').each do |game|
        Game.update_all ['favoriteships_count=?', game.favoriteships.count], ['id=?', game.id]
      end
    end
    
    desc "Update games.playables_count"
    task :playables_count => :environment do
      Game.update_all 'playables_count=0'
      Game.find(:all, :include => :playables, :conditions => 'playables.id IS NOT NULL').each do |game|
        Game.update_all ['playables_count=?', game.playables.count], ['id=?', game.id]
      end
    end
  end

  namespace :arcades do
    desc "Update arcades.frequentships_count"
    task :frequentships_count => :environment do
      Arcade.update_all 'frequentships_count=0'
      Arcade.find(:all, :include => :frequentships, :conditions => 'frequentships.id IS NOT NULL').each do |arcade|
        Arcade.update_all ['frequentships_count=?', arcade.frequentships.count], ['id=?', arcade.id]
      end
    end
    
    desc "Update arcades.playables_count"
    task :playables_count => :environment do
      Arcade.update_all 'playables_count=0'
      Arcade.find(:all, :include => :playables, :conditions => 'playables.id IS NOT NULL').each do |arcade|
        Arcade.update_all ['playables_count=?', arcade.playables.count], ['id=?', arcade.id]
      end
    end
  end
  
  
  
end