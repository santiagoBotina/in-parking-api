class DeletePaymentInfoColumn < ActiveRecord::Migration[7.1]
  def change
    remove_column :payments, :payment_info_id
  end
end
