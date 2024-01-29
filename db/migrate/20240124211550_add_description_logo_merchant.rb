class AddDescriptionLogoMerchant < ActiveRecord::Migration[7.1]
  def change
    add_column :lessors, :cognito_id, :string
    add_column :lessors, :description, :string
    add_column :lessors, :logo, :string
  end
end
