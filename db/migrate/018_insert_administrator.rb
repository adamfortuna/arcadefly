class InsertAdministrator < ActiveRecord::Migration
  
  def self.up
    #Then, add default admin user
    #Be sure change the password later or in this migration file
    us = Country.find_by_name('United States of America')
    florida = Region.find_by_name('Florida')
    
    user = User.new :email => 'adam@fortuna.name',
                    :password => 'password',
                    :password_confirmation => 'password'

    user.profile = Profile.new :display_name => 'Adam',
                               :full_name => 'Adam Fortuna',
                               :website => 'http://www.adamfortuna.com',
                               :about_me => 'I\'m the creator of this site.',
                               :aim_name => 'Dyogenez',
                               :gtalk_name => 'adam@fortuna.name',
                               :msn_name => 'adam@fortuna.name',
                               :initials => 'dyo'
                               
    
    user.profile.address = Address.new :title => 'Home',
                                       :street => '1130 Summer Lakes Drive',
                                       :city => 'Orlando',
                                       :region => florida,
                                       :country => us,
                                       :postal_code => 32835
    user.save!
    user.send(:activate!)
    
    user.make_administrator!
  end
 
  def self.down
    execute 'TRUNCATE users' 
  end
end