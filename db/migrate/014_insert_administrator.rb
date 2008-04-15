class InsertAdministrator < ActiveRecord::Migration
  
  def self.up
    #Make sure the role migration file was generated first    
    role = Role.new(:rolename => 'administrator')
    role.save()
    
    #Then, add default admin user
    #Be sure change the password later or in this migration file
    us = Country.find_by_name('United States of America')
    florida = Region.find_by_name('Florida')
    
    user = User.new :login => 'adam',
                    :email => 'adam@fortuna.name',
                    :password => 'password',
                    :password_confirmation => 'password'
    user.address = Address.new :title => 'Home',
                               :street => '1130 Summer Lakes Drive',
                               :city => 'Orlando',
                               :region => florida,
                               :country => us,
                               :postal_code => 32835
    user.save!
    user.send(:activate!)
    
    role = Role.find_by_rolename('administrator')
    permission = Permission.new :user => user, :role => role
    permission.save(false)
  end
 
  def self.down
    Role.find_by_rolename('administrator').destroy   
    User.find_by_login('admin').destroy   
    Permission.find_by_user_id(user.id).destroy
  end
end