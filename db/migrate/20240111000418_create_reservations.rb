class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations, id: false do |t|
      t.string :id
      t.integer :user_id
      t.string :spot_id
      t.string :vehicle_plate
      t.string :reservation_type
      t.datetime :reserved_until
      t.timestamps
    end
  end
end
