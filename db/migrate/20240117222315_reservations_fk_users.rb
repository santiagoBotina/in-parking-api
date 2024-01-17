class ReservationsFkUsers < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :reservations, :users, column: :user_id
  end
end
