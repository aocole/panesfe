class AddRowOrderToSlide < ActiveRecord::Migration
  def change
    add_column :slides, :row_order, :integer
    connection.execute "update slides set row_order = id"
  end
end
