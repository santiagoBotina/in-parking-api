class CreateSpots < ActiveRecord::Migration[7.1]
  def change
    create_table :spots do |t|
      t.integer :lessor_id
      t.string :address
      t.string :city
      t.string :vehicle_type

      t.timestamps
    end
    add_foreign_key :spots, :lessors, column: :lessor_id
    change_column_default :spots, :created_at, -> { 'CURRENT_TIMESTAMP' }
    change_column_default :spots, :updated_at, -> { 'CURRENT_TIMESTAMP' }
  end
end
