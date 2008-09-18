require 'hpricot'
require 'open-uri'

class Grabber
  DDRFREAK_LOCATIONS = 'http://www.ddrfreak.com/locations'
  
  def self.ddrfreak
    html = open("#{DDRFREAK_LOCATIONS}/locations.php")
    page = Hpricot(html)   

    page.search("//html/body/table/tr/td[@class=standardtext]/p/table[@class=standardtext]/tr/td/ul/li/a").each do |region|
      process_ddrfreak_region(region)
    end
  end
  
  
  
  def self.process_ddrfreak_region(region)
    puts region
    region_name = region.inner_html
    link = region['href']
    return unless region_record = Region.find_by_name(region_name)
    return if region_record.name == 'Florida' || region_record.name == 'Georgia'

    region_html = open("#{DDRFREAK_LOCATIONS}/#{link}")
    region_content = Hpricot(region_html)
    region_content.search("//html/body/table/tr/td[@class=standardtext]/p/table[@class=standardtext]/tr/tr[@bgcolor=#CFDCF8]").each do |arcade|
      process_ddrfreak_arcade(arcade, region_record)
    end
  rescue Exception => e
    puts "Skipping a region..."
  end
  
  def self.process_ddrfreak_arcade(arcade_row, region)
    a = arcade_row.search("/td/a").first
    link = a['href']
    arcade_name = a.inner_html
    city = arcade_row.search("/td")[1].inner_html
    games = arcade_row.search("/td")[2].inner_html.split(',')

    arcade = Arcade.find(:first, :conditions => ['name = ? AND addresses.region_id = ? AND addresses.city = ?', arcade_name, region.id, city], :include => :address)
    return if arcade
    arcade = Arcade.new({ :name => arcade_name, :address => Address.new })
    
    arcade_html = open("#{DDRFREAK_LOCATIONS}/#{link}")
    arcade_content = Hpricot(arcade_html)
    
    google_maps = arcade_content.search("//html/body/table/tr/td[@class=standardtext]/a")[1]
    return unless google_maps
    address_string = google_maps['href'].split('&').last.split('=').last.tr('+', ' ')    
    geo_address = Address.geocode(address_string)
    
    return unless geo_address
    arcade.address.street = geo_address.street_address
    arcade.address.postal_code = geo_address.zip
    arcade.address.city = geo_address.city
    arcade.address.country_id = 1
    arcade.address.region = region
    
    games.each do |game|
      matching_games = Game.search game
      begin
        arcade.playables << Playable.new({:game_id => matching_games.first.id, :games_count => 1}) if matching_games
      rescue Exception => e
      end
    end
    
    arcade.save
  rescue Exception => e
    puts "Skipping an arcade..."
  end
  
  
end