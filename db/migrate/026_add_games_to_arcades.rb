class AddGamesToArcades < ActiveRecord::Migration
  def self.up
#    a = Arcade.find(:all)
#    25.times do |time| 
#      a.each do |arcade| 
#        game_id = 1+rand(500)
#       if !Playable.find_by_arcade_id_and_game_id(arcade.id, game_id)
#          arcade.add_game(game_id, 1+rand(5))
#        end
#      end
#    end
  end

  def self.down
#    execute "TRUNCATE playables"
  end
end
