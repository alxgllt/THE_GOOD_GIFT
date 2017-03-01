class CreateCartProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :cart_products do |t|
      t.references :product, foreign_key: true
      t.references :cart

      t.timestamps
    end
  end
end
