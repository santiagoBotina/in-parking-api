class CreateMerchants < ActiveRecord::Migration[7.1]
  def change
    create_table :merchants do |t|
      t.string :legal_name
      t.text :legal_id_type
      t.string :legal_id
      t.string :contact_name
      t.string :phone
      t.string :email
      t.string :address
      t.string :city
      t.string :status
      t.string :bank_account_type
      t.string :bank_account_number

      t.timestamps
    end
    add_index :merchants, :legal_id, unique: true
  end
end
