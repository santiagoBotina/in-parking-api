class AddIsVerifiedMerchant < ActiveRecord::Migration[7.1]
  def change
    add_column :merchants, :is_verified, :boolean, default: false
    change_column_default :merchants, :status, 'INACTIVE'
  end
end
