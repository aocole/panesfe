class PluralizeBrokenMessage < ActiveRecord::Migration
  def change
    rename_column :presentations, :broken_message, :broken_message_keys
  end
end
