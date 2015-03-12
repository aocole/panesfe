class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.string :name
      t.references :user, index: true, null: false
      t.text :content

      t.timestamps
    end
  end
end
