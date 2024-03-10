class AddReservationStatus < ActiveRecord::Migration[7.1]
    def self.up
      execute <<-DDL
      CREATE TYPE reservation_status AS ENUM ('ACTIVE', 'CANCELLED', 'MISSED');
      ALTER TABLE reservations ADD COLUMN status reservation_status NOT NULL DEFAULT 'ACTIVE';
    DDL
    end

    def self.down
      execute <<-DDL
      DROP TYPE reservation_status;
      ALTER TABLE reservations DROP COLUMN status; 
    DDL
    end
end
