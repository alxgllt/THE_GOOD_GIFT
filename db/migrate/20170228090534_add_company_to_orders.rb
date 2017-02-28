class AddCompanyToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :company, :string
  end
end
