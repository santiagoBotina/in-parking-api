class SetDefaultTimestampsMerchant < ActiveRecord::Migration[7.1]
  def change
    change_column_default :lessors, :created_at, -> { 'CURRENT_TIMESTAMP' }
    change_column_default :lessors, :updated_at, -> { 'CURRENT_TIMESTAMP' }
  end
end
