class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :legal_id_type, null: false
      t.string :legal_id, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.string :password, null: false
      t.string :status, null: false, default: 'INACTIVE'
      t.boolean :is_verified, null: false, default: false
      t.timestamps
    end
  end
end
