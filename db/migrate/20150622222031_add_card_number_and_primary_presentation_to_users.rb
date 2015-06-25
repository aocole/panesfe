class AddCardNumberAndPrimaryPresentationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :card_number, :integer
    add_column :users, :primary_presentation_id, :integer
    add_index :users, :card_number, unique: true
  end
end
