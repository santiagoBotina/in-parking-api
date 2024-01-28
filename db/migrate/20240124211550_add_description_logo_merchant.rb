class AddDescriptionLogoMerchant < ActiveRecord::Migration[7.1]
  def change
    add_column :merchants, :cognito_id, :string
    add_column :merchants, :description, :string
    add_column :merchants, :logo, :string
  end
end
