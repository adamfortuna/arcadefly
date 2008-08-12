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
            if game = Game.find_by_name(name)
              game.update_attribute(:gamefaqs_id, gamefaqs_id)
            else
              Game.create({:name => name, :gamefaqs_id => gamefaqs_id})
            end
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
              
              games = Game.search(name)
              
              if games.length == 1
                games[0].update_attribute(:klov_id, klov_id)
              elsif games.length > 1
                puts "\"#{name}\" not found. Closest Results:"
                games.each_with_index do |game, index|
                  puts "#{index}. #{game.name}"
                end
                puts "Any of these match? (hit enter for none): "
                match = STDIN.gets.chomp
                
                if match.length == 0
                  puts "Creating new game for #{name}..."
                  Game.create({:name => name, :klov_id => klov_id})
                else games[match.to_i]
                  puts "Updating to choice #{match}..."
                  games[match.to_i].update_attribute(:klov_id, klov_id)
                end
              else
                Game.create({:name => name, :klov_id => klov_id})
              end
            end
            @klov_ids << klov_id
          end
        end
      end
      puts "Updated games.klov_id"
    end
    
  end
end