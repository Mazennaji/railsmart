class AddStripeToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :stripe_session_id, :string
    add_column :orders, :paid_at, :datetime
  end
end
