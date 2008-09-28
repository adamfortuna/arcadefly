require 'hpricot'
require 'open-uri'

class Grabber
  DDRFREAK_LOCATIONS = 'http://www.ddrfreak.com/locations'
  
  def self.ddrfreak
    html = open("#{DDRFREAK_LOCATIONS}/locations.php?regionID=2&action=displayRegion")
    page = Hpricot(html)   

    page.search("//html/body/table/tr/td[@class=standardtext]/p/table[@class=standardtext]/tr/td/ul/li/a").each do |region|
      process_ddrfreak_region(region)
    end
  end
  
  
  
  def self.process_ddrfreak_region(region)
    puts region
    region_name = region.inner_html
    link = region['href']
    if region_record = Region.find_by_name(region_name)
      puts "\n\n\n\n\n\nRegion found! #{region_name}"
    else
      puts "Region not found! #{region_name}"
      return
    end


    region_html = open("#{DDRFREAK_LOCATIONS}/#{link}")
    region_content = Hpricot(region_html)
    region_content.search("//html/body/table/tr/td[@class=standardtext]/p/table[@class=standardtext]/tr/tr[@bgcolor=#CFDCF8]").each do |arcade|
      process_ddrfreak_arcade(arcade, region_record)
    end
  rescue Exception => e
    puts "Skipping a region due to an exception..."
  end
  
  def self.process_ddrfreak_arcade(arcade_row, region)
    puts "\n\n New Arcade..."
    a = arcade_row.search("/td/a").first
    link = a['href']
    arcade_name = a.inner_html
    city = arcade_row.search("/td")[1].inner_html
    games = arcade_row.search("/td")[2].inner_html.split(',')

    arcade = Arcade.find(:first, :conditions => ['name = ? AND addresses.region_id = ? AND addresses.city = ?', arcade_name, region.id, city], :include => :address)
    if arcade
      puts "Arcade already exists: #{arcade_name}"
      return
    else 
      puts "Creating new arcade... #{arcade_name}"
    end
    arcade = Arcade.new({ :name => arcade_name, :address => Address.new })
    
    arcade_html = open("#{DDRFREAK_LOCATIONS}/#{link}")
    arcade_content = Hpricot(arcade_html)
    
    google_maps = arcade_content.search("//html/body/table/tr/td[@class=standardtext]/a")[1]
    if !google_maps
      puts "Unable to find link to Google maps.. skipping #{arcade_name}"
      return
    end
    address_string = google_maps['href'].split('&').last.split('=').last.tr('+', ' ')    
    geo_address = Address.geocode(address_string)
    
    if !geo_address
      puts "Unable to geocode address for #{arcade_name} -- #{address_string}"
      return
    end
    
    puts "geo address: #{geo_address}"

    arcade.address.street = geo_address.street_address
    arcade.address.postal_code = geo_address.zip
    arcade.address.city = geo_address.city
    arcade.address.country_id = 4
    arcade.address.region = region
    
    puts "Single Line: #{arcade.address.single_line}"

    Arcade.transaction do 
      if !arcade.save
        puts "Unable to save arcade #{arcade_name}: #{arcade.errors.collect { |e| e } }"
      end

      games.each do |game|
        matching_games = Game.search game
        if matching_games.length > 0
          begin
            arcade.playables << Playable.new({:game_id => matching_games.first.id, :games_count => 1}) if matching_games
          rescue Exception => e
            puts "\n\n\n\n\n\n\n\nUnable to add game to arcade: #{arcade_name} - #{matching_games.first.name}\n\n\n\n\n\n\n"
            arcade.playables.each do |playable|
              if playable.game_id == matching_games.first.id
                playable.increment!(:games_count)
              end
            end
          end
        end
      end
    end
  
  rescue Exception => e
    puts "Skipping an arcade due to an exception... #{e.backtrace.join('\n')}"
  end
  
  
end