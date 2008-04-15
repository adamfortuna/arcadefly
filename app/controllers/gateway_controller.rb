require 'hpricot'
require 'open-uri'

class GatewayController < ApplicationController
  before_filter :check_administrator_role
  
  def update_games
    letters = ('a'..'z').to_a << '0'
    
    letters.each do |letter|
    
      page = Hpricot(open('http://www.gamefaqs.com/coinop/arcade/list_'+letter+'.html'))   
    
      page.search( "//div#container/div#content/div#sky_col_wrap/div#main_col_wrap/div#main_col/div[@class='pod']/div[@class='body']/table/tr" ).each do |g|
        a = g.search( "//td:first/a").first
        name = a.inner_html
        link = a['href']
        gamefaqs_id = link.match(/[0-9]+/)[0]
            
        # Create this game if it doesn't exist
        if !Game.find_by_gamefaqs_id(gamefaqs_id, :select => 'true')
          Game.create(:name => name, :gamefaqs_id => gamefaqs_id)
        end
      end
    end
    
    render :template => "games/update" 
  end
end