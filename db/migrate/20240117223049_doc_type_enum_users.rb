class DocTypeEnumUsers < ActiveRecord::Migration[7.1]
  def self.up
    execute <<-DDL
      CREATE TYPE legal_id_type AS ENUM ('CC', 'NIT', 'PP', 'CE', 'TI');
      ALTER TABLE users ALTER COLUMN legal_id_type TYPE legal_id_type USING legal_id_type::legal_id_type;
    DDL
  end

  def self.down
    execute <<-DDL
      DROP TYPE legal_id_type;
      ALTER TABLE users ALTER COLUMN legal_id_type TYPE VARCHAR; 
    DDL
  end
end
