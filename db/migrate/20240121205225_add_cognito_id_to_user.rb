class AddCognitoIdToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :cognito_id, :string
  end
end
