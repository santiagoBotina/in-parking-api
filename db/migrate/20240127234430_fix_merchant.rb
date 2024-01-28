class FixMerchant < ActiveRecord::Migration[7.1]
  def change
    add_column :merchants, :password, :string
    remove_column :merchants, :contact_last_name, :string
  end
end
