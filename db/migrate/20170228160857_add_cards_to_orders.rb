class AddCardsToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :card, :string
  end
end
