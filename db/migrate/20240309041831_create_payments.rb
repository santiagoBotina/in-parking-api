class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.integer :lessor_id
      t.integer :reservation_id
      t.integer :spot_id
      t.integer :amount_in_cents
      t.string :status
      t.string :payment_type
      t.integer :payment_info_id

      t.timestamps
    end

    add_foreign_key :payments, :lessors, column: :lessor_id
    add_foreign_key :payments, :users, column: :user_id
    add_foreign_key :payments, :reservations, column: :reservation_id
    add_foreign_key :payments, :spots, column: :spot_id
    change_column_default :payments, :created_at, -> { 'CURRENT_TIMESTAMP' }
    change_column_default :payments, :updated_at, -> { 'CURRENT_TIMESTAMP' }
  end
end
