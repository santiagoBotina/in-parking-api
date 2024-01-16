class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations, :primary_key => :id do |t|
      t.integer :user_id
      t.string :spot_id
      t.string :vehicle_plate
      t.string :reservation_type
      t.datetime :reserved_until
      t.timestamps
    end
  end
end
