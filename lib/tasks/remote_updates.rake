require 'hpricot'
require 'open-uri'
namespace :update do
  
  namespace :games do
    
    desc "Update all games from gamefaqs"
    task :gamefaqs_id => :environment do
      letters = ('a'..'z').to_a << '0'
    
      @gamefaq_ids = Game.find(:all).collect(&:gamefaqs_id)
        
      letters.each do |letter|
    
        html = open('http://www.gamefaqs.com/coinop/arcade/list_'+letter+'.html')
        page = Hpricot(html)   
    
        page.search( "//div#container/div#content/div#sky_col_wrap/div#main_col_wrap/div#main_col/div[@class='pod']/div[@class='body']/table/tr" ).each do |g|
          a = g.search( "//td:first/a").first
          name = a.inner_html
          link = a['href']
          gamefaqs_id = link.match(/[0-9]+/)[0]
            
          # Add this games data if it doesn't exist
          if !@gamefaq_ids.include?(gamefaqs_id)
            Game.create({:name => name, :gamefaqs_id => gamefaqs_id})
            @gamefaq_ids << gamefaqs_id
          end
        end
      end
      puts "Updated games.gamefaqs_id"
    end
    
    desc "Update all games from klov"
    task :klov_id => :environment do
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
            if game = Game.find_by_name(name)
              game.update_attribute(:klov_id, klov_id)
            else
              Game.create({:name => name, :klov_id => klov_id})
            end
            @klov_ids << klov_id
          end
        end
      end
      puts "Updated games.klov_id"
    end
    
  end
end