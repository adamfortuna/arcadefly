require 'hpricot'
require 'open-uri'
namespace :update do
  
  namespace :games do
    
    desc "Update all pinball games"
    task :pinball => :environment do
      html = open('http://en.wikipedia.org/wiki/List_of_pinball_machines')
      page = Hpricot(html)   
  
      pinballs = page.search( "//div#bodyContent/ul//li//a" ).collect(&:innerHTML)
      pinballs.pop()
      pinballs.pop()
      pinballs.each do |name|
        games = Game.find_by_name("#{name} Pinball")
        if games
          puts "\"#{name} Pinball\" found. Skipping.."
        else
          games = Game.search("#{name} Pinball")
          if games.length > 0
            puts "\"#{name}\" not found. Closest Results:"
            games.each_with_index do |game, index|
              puts "#{index}. #{game.name}"
            end
            puts "Any of these match? (hit enter for none): "
            match = STDIN.gets.chomp
      
            if match.length == 0
              puts "Creating new game for #{name}..."
              Game.create({:name => "#{name} Pinball"})
            elsif match.length == -1
              puts "Not adding..."
            else games[match.to_i]
              puts "Already added, skipping ..."
            end
          else
            Game.create({:name => "#{name} Pinball"})
          end 
        end
      end
    end
  end
end