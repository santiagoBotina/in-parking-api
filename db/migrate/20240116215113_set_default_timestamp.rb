class SetDefaultTimestamp < ActiveRecord::Migration[7.1]
  def change
    change_column_default :reservations, :created_at, -> { 'CURRENT_TIMESTAMP' }
    change_column_default :reservations, :updated_at, -> { 'CURRENT_TIMESTAMP' }
  end
end
