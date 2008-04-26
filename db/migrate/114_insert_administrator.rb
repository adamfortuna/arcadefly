class InsertAdministrator < ActiveRecord::Migration
  
  def self.up
    #Then, add default admin user
    #Be sure change the password later or in this migration file
    us = Country.find_by_name('United States of America')
    florida = Region.find_by_name('Florida')
    
    user = User.new :login => 'adam',
                    :email => 'adam@fortuna.name',
                    :name => 'Adam Fortuna',
                    :password => 'password',
                    :password_confirmation => 'password',
                    :administrator => true
    user.address = Address.new :title => 'Home',
                               :street => '1130 Summer Lakes Drive',
                               :city => 'Orlando',
                               :region => florida,
                               :country => us,
                               :postal_code => 32835
    user.save!
    user.send(:activate!)
  end
 
  def self.down
    execute 'TRUNCATE users' 
  end
end