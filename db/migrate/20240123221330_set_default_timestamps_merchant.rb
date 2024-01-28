class SetDefaultTimestampsMerchant < ActiveRecord::Migration[7.1]
  def change
    change_column_default :merchants, :created_at, -> { 'CURRENT_TIMESTAMP' }
    change_column_default :merchants, :updated_at, -> { 'CURRENT_TIMESTAMP' }
  end
end
