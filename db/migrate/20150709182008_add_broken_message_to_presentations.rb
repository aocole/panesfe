class AddBrokenMessageToPresentations < ActiveRecord::Migration
  def change
    add_column :presentations, :broken_message, :string
  end
end
