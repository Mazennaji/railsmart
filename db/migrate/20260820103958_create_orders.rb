class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.string :customer_name
      t.string :email
      t.text :address
      t.string :status
      t.decimal :total

      t.timestamps
    end
  end
end
