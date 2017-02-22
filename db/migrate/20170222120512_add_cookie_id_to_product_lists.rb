class AddCookieIdToProductLists < ActiveRecord::Migration[5.0]
  def change
    add_column :product_lists, :session_id, :string
  end
end
