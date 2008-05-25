class ImportCountries < ActiveRecord::Migration
  def self.up
    Country.create(:name=>'United States of America', :alpha_2_code => 'US', :alpha_3_code => 'USA' )
    Country.create(:name=>'Australia', :alpha_2_code => 'AU', :alpha_3_code => 'AUS' )
    Country.create(:name=>'Brazil', :alpha_2_code => 'BR', :alpha_3_code => 'BRA' )
    Country.create(:name=>'Canada', :alpha_2_code => 'CA', :alpha_3_code => 'CAN' )
    Country.create(:name=>'Ireland', :alpha_2_code => 'IE', :alpha_3_code => 'IRL' )
    Country.create(:name=>'Japan', :alpha_2_code => 'JP', :alpha_3_code => 'JPN' )
    Country.create(:name=>'Mexico', :alpha_2_code => 'MX', :alpha_3_code => 'MEX' )
    Country.create(:name=>'South Korea', :alpha_2_code => 'KR', :alpha_3_code => 'KOR' )
    Country.create(:name=>'Ireland', :alpha_2_code => 'IE', :alpha_3_code => 'IRL' )
    Country.create(:name=>'United Kingdom', :alpha_2_code => 'GB', :alpha_3_code => 'GBR' )
  end

  def self.down
    execute "TRUNCATE countries"
  end
end