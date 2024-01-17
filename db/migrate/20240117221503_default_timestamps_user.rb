class DefaultTimestampsUser < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :created_at, -> { 'CURRENT_TIMESTAMP' }
    change_column_default :users, :updated_at, -> { 'CURRENT_TIMESTAMP' }
  end
end
