class AddSupplierToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :supplier_name, :string
  end
end
