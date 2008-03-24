class ImportCountries < ActiveRecord::Migration
  def self.up
    
    # Load in some sample countries
    #Optimize: Make thi use the Country model
    csv_file = "#{RAILS_ROOT}/db/migrate/country_data.csv"
    fields = '(name, official_name, alpha_2_code, alpha_3_code, calling_code)'

    execute "LOAD DATA INFILE '#{csv_file}' INTO TABLE countries FIELDS " +
            "TERMINATED BY ',' OPTIONALLY ENCLOSED BY \"\"\"\" " +
            "LINES TERMINATED BY '\n' " + fields
            
  end

  def self.down
    execute "TRUNCATE countries"
  end
end