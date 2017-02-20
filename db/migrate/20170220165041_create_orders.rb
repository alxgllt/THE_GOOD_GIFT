class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :total_price
      t.date :delivery_date
      t.string :address
      t.string :status
      t.json :payment

      t.timestamps
    end
  end
end
