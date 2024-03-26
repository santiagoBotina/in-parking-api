class AddNotNullToLessorId < ActiveRecord::Migration[7.1]
  def change
    change_column_null :reservations, :lessor_id, false
  end
end
