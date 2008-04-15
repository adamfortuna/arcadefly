class ImportCountries < ActiveRecord::Migration
  def self.up
    Country.create(:name=>'United States of America', :alpha_2_code => 'US', :alpha_3_code => 'USA' )
    Country.create(:name=>'Canada', :alpha_2_code => 'CA', :alpha_3_code => 'CAN' )
  end

  def self.down
    execute "TRUNCATE countries"
  end
end