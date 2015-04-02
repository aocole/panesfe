class AddDescriptionToThemes < ActiveRecord::Migration
  def change
    add_column :themes, :description, :string
  end
end
