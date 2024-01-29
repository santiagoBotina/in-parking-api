class AddReservationCheckIn < ActiveRecord::Migration[7.1]
  def change
    add_column :reservations, :check_in, :datetime
    add_column :reservations, :lessor_id, :integer

    change_column :reservations, :spot_id, :integer, using: 'spot_id::integer'

    add_foreign_key :reservations, :lessors, column: :lessor_id
    add_foreign_key :reservations, :spots, column: :spot_id

    rename_column :reservations, :reserved_until, :check_out
  end
end
