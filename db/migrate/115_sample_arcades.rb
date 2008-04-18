class SampleArcades < ActiveRecord::Migration
  def self.up

    us = Country.find_by_name('United States of America')
    florida = Region.find_by_name('Florida')
    
    Arcade.create :name => 'Rocky\'s Replay',
                  :phone => '(407) 260-0043',
                  :address => Address.new ( :title => 'test',
                                            :street => '1121 Semoran Blvd',
                                            :city => 'Casselberry',
                                            :region => florida,
                                            :country => us,
                                            :postal_code => 32707 )
                  

    Arcade.create :name => 'Beach Gameland', 
                  :phone => '(727) 444-4494',
                  :address => Address.new ( :title => 'test',
                                            :street => '483 Mandalay Avenue',
                                            :city => 'Clearwater Beach',
                                            :region => florida,
                                            :country => us,
                                            :postal_code => 33767 )

    Arcade.create :name => 'Magical Midway', 
                  :phone => '(407) 370-5353',
                  :address => Address.new ( :title => 'test',
                                            :street => '7001 International Drive',
                                            :city => 'Orlando',
                                            :region => florida,
                                            :country => us,
                                            :postal_code => 32819 )

    Arcade.create :name => 'Disney Quest', 
                  :address => Address.new ( :title => 'test',
                                            :street => '1486 E Buena Vista Dr',
                                            :city => 'Lake Buena Vista',
                                            :region => florida,
                                            :country => us,
                                            :postal_code => 32830 )

    Arcade.create :name => 'Vans Skate Park', 
                  :phone => '(407) 351-3881',
                  :address => Address.new ( :title => 'test',
                                            :street => '5220 International Drive',
                                            :city => 'Orlando',
                                            :region => florida,
                                            :country => us,
                                            :postal_code => 32830 )

    Arcade.create :name => 'Wackadoo\'s Grub and Brew',
                  :phone => '(407) 282-1900',
                  :address => Address.new ( :title => 'test',
                                            :street => '4000 Central Florida Blvd.',
                                            :city => 'Orlando',
                                            :region => florida,
                                            :country => us,
                                            :postal_code => 32816 )

    Arcade.create :name => 'Fantasy Arcade at Festival Bay',
                  :phone => '(407) 468-1099',
                  :address => Address.new ( :title => 'test',
                                            :street => '5250 International Drive',
                                            :city => 'Orlando',
                                            :region => florida,
                                            :country => us,
                                            :postal_code => 32819 )
  
    Arcade.create :name => 'For Your Entertainment at Oviedo Marketplace',
                  :phone => '(407) 977-4700',
                  :address => Address.new ( :title => 'test',
                                            :street => '1700 Oviedo Marketplace Blvd.',
                                            :city => 'Oviedo',
                                            :region => florida,
                                            :country => us,
                                            :postal_code => 32765 )
  
    Arcade.create :name => 'Wonderworks',
                  :phone => '(407) 351-8800',
                  :address => Address.new ( :title => 'test',
                                            :street => '9067 International Drive',
                                            :city => 'Orlando',
                                            :region => florida,
                                            :country => us,
                                            :postal_code => 32819 )
  
    Arcade.create :name => 'Kingpin\'s Arcade at Islands of Adventure',
                  :phone => '(407) 363-8000',
                  :address => Address.new( :title => 'test',
                                           :street => '1000 Universal Studios Plaza',
                                           :city => 'Orlando',
                                           :region => florida,
                                           :country => us,
                                           :postal_code => 32819 )
  end

  def self.down
    execute 'TRUNCATE arcades'
    execute 'TRUNCATE addresses'
    execute 'TRUNCATE playables'
  end
end
