class AddLastNameMerchant < ActiveRecord::Migration[7.1]
  def change
    add_column :merchants, :contact_last_name, :string
  end
end
