class FixMerchant < ActiveRecord::Migration[7.1]
  def change
    add_column :lessors, :password, :string
  end
end
