class AddStatusesToPayments < ActiveRecord::Migration[7.1]
  def self.up
    execute <<-DDL
      CREATE TYPE payment_status_type AS ENUM ('APPROVED', 'PENDING', 'DECLINED', 'REFUNDED');
      ALTER TABLE payments ALTER COLUMN status TYPE payment_status_type USING status::payment_status_type;
      ALTER TABLE payments ALTER COLUMN status SET NOT NULL;
    DDL
  end

  def self.down
    execute <<-DDL
      DROP TYPE payment_status_type;
      ALTER TABLE payments ALTER COLUMN status TYPE VARCHAR(15); 
    DDL
  end
end
