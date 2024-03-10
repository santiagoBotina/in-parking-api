class CreatePaymentTypeEnum < ActiveRecord::Migration[7.1]
  def self.up
    execute <<-DDL
      CREATE TYPE payment_type AS ENUM ('ONLINE', 'CASH');
      ALTER TABLE payments ALTER COLUMN payment_type TYPE payment_type USING payment_type::payment_type;
      ALTER TABLE payments ALTER COLUMN payment_type SET NOT NULL;
    DDL
  end

  def self.down
    execute <<-DDL
      DROP TYPE payment_type;
      ALTER TABLE payments ALTER COLUMN payment_type TYPE VARCHAR; 
    DDL
  end
end
