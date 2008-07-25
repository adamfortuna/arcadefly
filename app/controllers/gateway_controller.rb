require 'hpricot'
require 'open-uri'
class GatewayController < ApplicationController
  before_filter :check_administrator
  
  def update_games
    @letter ||= params[:letter] || 'a'
    letters = (@letter..'z').to_a << '0'
    
    @gamefaq_ids = Game.find(:all).collect(&:gamefaqs_id)
        
    for @letter in letters
    
      html = open('http://www.gamefaqs.com/coinop/arcade/list_'+@letter+'.html')
      page = Hpricot(html)   
    
      page.search( "//div#container/div#content/div#sky_col_wrap/div#main_col_wrap/div#main_col/div[@class='pod']/div[@class='body']/table/tr" ).each do |g|
        a = g.search( "//td:first/a").first
        name = a.inner_html
        link = a['href']
        gamefaqs_id = link.match(/[0-9]+/)[0].to_i
            
        # Add this games data if it doesn't exist
        if !@gamefaq_ids.include?(gamefaqs_id)
          Game.create({:name => name, :gamefaqs_id => gamefaqs_id})
          @gamefaq_ids << gamefaqs_id
        end
      end
    end

    render :template => "games/update"
  end
  
  def login
    redirect_to signin_path
  end
end