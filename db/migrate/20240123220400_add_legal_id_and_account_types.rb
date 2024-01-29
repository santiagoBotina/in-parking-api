class AddLegalIdAndAccountTypes < ActiveRecord::Migration[7.1]
  def self.up
    execute <<-DDL
      CREATE TYPE bank_account_type AS ENUM ('SAVINGS', 'CHECKING');
      CREATE TYPE user_account_status AS ENUM ('ACTIVE', 'INACTIVE');
      ALTER TABLE lessors ALTER COLUMN legal_id_type TYPE legal_id_type USING legal_id_type::legal_id_type;
      ALTER TABLE lessors ALTER COLUMN bank_account_type TYPE bank_account_type USING bank_account_type::bank_account_type;
      ALTER TABLE lessors ALTER COLUMN status TYPE user_account_status USING status::user_account_status;
    DDL
  end

  def self.down
    execute <<-DDL
      DROP TYPE bank_account_type;
      DROP TYPE user_account_status;
      ALTER TABLE lessors ALTER COLUMN legal_id_type TYPE VARCHAR; 
      ALTER TABLE lessors ALTER COLUMN bank_account_type TYPE VARCHAR; 
      ALTER TABLE lessors ALTER COLUMN status TYPE VARCHAR; 
    DDL
  end
end
