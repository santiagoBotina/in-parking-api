class CreateMerchants < ActiveRecord::Migration[7.1]
  def change
    create_table :lessors do |t|
      t.string :legal_name, null: true
      t.text :legal_id_type
      t.string :legal_id
      t.string :lessor_name
      t.string :phone
      t.string :email
      t.string :address
      t.string :city
      t.string :status
      t.string :bank_account_type
      t.string :bank_account_number

      t.timestamps
    end
    add_index :lessors, :legal_id, unique: true
  end
end
