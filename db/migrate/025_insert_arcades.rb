class InsertArcades < ActiveRecord::Migration
  def self.up

    us = Country.find_by_name('United States of America')
    florida = Region.find_by_name('Florida')
    
    Arcade.create :name => 'Rocky\'s Replay',
                  :phone => '(407) 260-0043',
                  :address => Address.new ( :street => '1121 Semoran Blvd',
                                            :city => 'Casselberry',
                                            :region => florida,
                                            :country => us,
                                            :postal_code => 32707 )
                  

    Arcade.create :name => 'Universal Studios Citywalk - AMC Universal Cineplex', 
                  :phone => '(407) 354-3374',
                  :notes => 'You must buy a ticket to get to where the games are. They are downstairs under the escalator.',
                  :address => Address.new ( :street => '6000 Universal Blvd., Ste 740',
                                            :city => 'Orlando',
                                            :region => florida,
                                            :country => us,
                                            :postal_code => 32819 )

    Arcade.create :name => 'Magical Midway', 
                  :phone => '(407) 370-5353',
                  :address => Address.new ( :street => '7001 International Drive',
                                            :city => 'Orlando',
                                            :region => florida,
                                            :country => us,
                                            :postal_code => 32819 )

    Arcade.create :name => 'Disney Quest', 
                  :notes => 'You have to pay to get into Disney Quest.',
                  :address => Address.new ( :street => '1486 E Buena Vista Dr',
                                            :city => 'Lake Buena Vista',
                                            :region => florida,
                                            :country => us,
                                            :postal_code => 32830 )

    Arcade.create :name => 'Vans Skate Park', 
                  :phone => '(407) 351-3881',
                  :address => Address.new ( :street => '5250 International Drive',
                                            :city => 'Orlando',
                                            :region => florida,
                                            :country => us,
                                            :postal_code => 32819 )

    Arcade.create :name => 'Wackadoo\'s Grub and Brew',
                  :phone => '(407) 282-1900',
                  :address => Address.new ( :street => '4000 Central Florida Blvd.',
                                            :city => 'Orlando',
                                            :region => florida,
                                            :country => us,
                                            :postal_code => 32816 )

    Arcade.create :name => 'Fantasy Arcade at Festival Bay',
                  :phone => '(407) 468-1099',
                  :address => Address.new ( :street => '5250 International Drive',
                                            :city => 'Orlando',
                                            :region => florida,
                                            :country => us,
                                            :postal_code => 32819 )
  
    Arcade.create :name => 'For Your Entertainment at Oviedo Marketplace',
                  :phone => '(407) 977-4700',
                  :address => Address.new ( :street => '1700 Oviedo Marketplace Blvd.',
                                            :city => 'Oviedo',
                                            :region => florida,
                                            :country => us,
                                            :postal_code => 32765 )
  
    Arcade.create :name => 'Wonderworks',
                  :phone => '(407) 351-8800',
                  :notes => 'You have to pay to get to the arcade.',
                  :address => Address.new ( :street => '9067 International Drive',
                                            :city => 'Orlando',
                                            :region => florida,
                                            :country => us,
                                            :postal_code => 32819 )
  
    Arcade.create :name => 'Kingpin\'s Arcade at Islands of Adventure',
                  :phone => '(407) 363-8000',
                  :address => Address.new( :street => '1000 Universal Studios Plaza',
                                           :city => 'Orlando',
                                           :region => florida,
                                           :country => us,
                                           :postal_code => 32819 )
                                           
    
    Arcade.create :name => 'Nickelodeon Family Suites',
                  :phone => '(866) 462-6425',
                  :address => Address.new( :street => '14500 Continental Gateway',
                                           :city => 'Orlando',
                                           :region => florida,
                                           :country => us,
                                           :postal_code => 32821 )
    
    Arcade.create :name => 'Fun Spot Action Park',
                  :phone => '(407) 363-3867',
                  :address => Address.new( :street => '5551 Del Verde Way',
                                           :city => 'Orlando',
                                           :region => florida,
                                           :country => us,
                                           :postal_code => 32819 )
    
    Arcade.create :name => 'Universal Studios - New York Penny Arcade',
                  :phone => '(407) 363-8000',
                  :address => Address.new( :street => '1000 Universal Studios Plaza',
                                           :city => 'Orlando',
                                           :region => florida,
                                           :country => us,
                                           :postal_code => 32837 )
    
    Arcade.create :name => 'Sea World Adventure Park',
                  :phone => '(407) 363-8000',
                  :address => Address.new( :street => '7007 Sea Harbor Dr.',
                                           :city => 'Orlando',
                                           :region => florida,
                                           :country => us,
                                           :postal_code => 32821 )
    
    Arcade.create :name => 'Regal Cinemas The Loop 16',
                  :phone => '(407) 343-0405',
                  :address => Address.new( :street => '3232 N. John Young Pkwy.',
                                           :city => 'Kissimmee',
                                           :region => florida,
                                           :country => us,
                                           :postal_code => 34741 )
    
    Arcade.create :name => 'AMC Altamonte Mall 18',
                  :phone => '(407) 551-2262',
                  :address => Address.new( :street => '433 East Altamonte Drive',
                                           :city => 'Altamonte',
                                           :region => florida,
                                           :country => us,
                                           :postal_code => 32701 )

    Arcade.create :name => 'AMC Pleasure Island 24',
                  :phone => '(407) 298-4488',
                  :notes => 'You must buy a movie ticket to get into the arcade. The games are scattered amongst the hallways outside the theaters.',
                  :address => Address.new( :street => '1500 E Buena Vista Dr',
                                           :city => 'Orlando',
                                           :region => florida,
                                           :country => us,
                                           :postal_code => 32830 )

    Arcade.create :name => 'Tilt at Fashion Square Mall',
                  :phone => '(407) 896-1131',
                  :address => Address.new( :street => '3201 East Colonial Drive',
                                           :city => 'Orlando',
                                           :region => florida,
                                           :country => us,
                                           :postal_code => 32822 )

    Arcade.create :name => 'AMC West Oaks 14',
                  :phone => '(407) 298-4488',
                  :notes => 'You must buy a movie ticket to get into the arcade. The games are scattered amongst the hallways outside the theaters.',
                  :address => Address.new( :street => '9401 West Colonial Drive',
                                           :city => 'Ocoee',
                                           :region => florida,
                                           :country => us,
                                           :postal_code => 34761 )

    Arcade.create :name => 'Regal Winter Park Village 20',
                  :phone => '(407) 628-0035',
                  :address => Address.new( :street => '510 N. Orlando Ave.',
                                           :city => 'Winter Park',
                                           :region => florida,
                                           :country => us,
                                           :postal_code => 32789 )
  end

  def self.down
    execute 'TRUNCATE arcades'
    execute 'TRUNCATE addresses'
    execute 'TRUNCATE playables'
  end
end
