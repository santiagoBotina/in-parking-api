class ReservationTypeEnum < ActiveRecord::Migration[7.1]
  def self.up
    execute <<-DDL
      CREATE TYPE reservation_type AS ENUM ('ONE_TIME', 'WEEKLY', 'MONTHLY');
      ALTER TABLE reservations ALTER COLUMN reservation_type TYPE reservation_type USING reservation_type::reservation_type;
    DDL
  end

  def self.down
    execute <<-DDL
      DROP TYPE reservation_type;
      ALTER TABLE reservations ALTER COLUMN reservation_type TYPE VARCHAR; 
    DDL
  end
end
