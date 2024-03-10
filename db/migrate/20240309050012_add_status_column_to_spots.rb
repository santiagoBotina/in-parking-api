class AddStatusColumnToSpots < ActiveRecord::Migration[7.1]
  def self.up
    execute <<-DDL
      CREATE TYPE spot_status AS ENUM ('AVAILABLE', 'RESERVED', 'PENDING', 'UNAVAILABLE');
      ALTER TABLE spots ADD status spot_status;
      ALTER TABLE spots ALTER COLUMN status SET NOT NULL;
    DDL
  end

  def self.down
    execute <<-DDL
      DROP TYPE spot_status;
      ALTER TABLE spots DROP COLUMN status; 
    DDL
  end
end
