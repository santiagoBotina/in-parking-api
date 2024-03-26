class AddPendingStatusToReservation < ActiveRecord::Migration[7.1]
  def self.up
    execute <<-DDL
      ALTER TYPE reservation_status ADD VALUE 'PENDING';
      COMMIT;
      ALTER TABLE reservations ALTER COLUMN status SET DEFAULT 'PENDING';
    DDL
  end

  def self.down
    execute <<-DDL
      ALTER TABLE reservations SET DEFAULT NULL;
      DROP TYPE reservation_status;
      CREATE TYPE reservation_status AS ENUM ('ACTIVE', 'CANCELLED', 'MISSED');
    DDL
  end
end
