class AddIsVerifiedMerchant < ActiveRecord::Migration[7.1]
  def change
    add_column :lessors, :is_verified, :boolean, default: false
    change_column_default :lessors, :status, 'INACTIVE'
  end
end
