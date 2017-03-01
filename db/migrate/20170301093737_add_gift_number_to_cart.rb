class AddGiftNumberToCart < ActiveRecord::Migration[5.0]
  def change
    add_column :carts, :gift_number, :integer
  end
end
