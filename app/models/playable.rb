# This describes what games are available a given arcade, and which arcades have a given game.
class Playable < ActiveRecord::Base
  belongs_to :arcade, :counter_cache => true
  belongs_to :game, :counter_cache => true

  after_destroy :update_playables_count

  validates_presence_of :games_count, :minimum => 0
  
  private
  def update_playables_count
    arcade.save
    game.save
  end
  
end