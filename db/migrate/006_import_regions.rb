class ImportRegions < ActiveRecord::Migration
  def self.up
    # Load in some sample regions
    #Optimize: Make thi use the Region model
    csv_file = "#{RAILS_ROOT}/db/migrate/region_data.csv"
    fields = '(country_id, name, abbreviation)'

    execute "LOAD DATA INFILE '#{csv_file}' INTO TABLE regions FIELDS " +
            "TERMINATED BY ',' OPTIONALLY ENCLOSED BY \"\"\"\" " +
            "LINES TERMINATED BY '\n' " + fields
  end

  def self.down
    execute "TRUNCATE regions"
  end
end