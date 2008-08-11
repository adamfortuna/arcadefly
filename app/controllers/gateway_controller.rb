require 'hpricot'
require 'open-uri'
class GatewayController < ApplicationController
  before_filter :check_administrator
  
  def update_games
    letters = ('a'..'z').to_a << '0'
  
    @klov_ids = Game.find(:all).collect(&:klov_id)
      
    letters.each do |letter|
  
      html = open('http://www.klov.com/game_list.php?letter='+letter+'&type=Videogame')
      page = Hpricot(html)   

      page.search("//body/table[2]/tr/td/a").each do |a|
        name = a.inner_html
        link = a['href']
        klov_id = link.match(/[0-9]+/)[0]
          
        # Add this games data if it doesn't exist
        if !@klov_ids.include?(klov_id)
          Game.update("klov_id = #{klov_id}", "name = #{name}")
          @klov_ids << klov_id
        end
      end
    end

    render :template => "games/update"
  end
end