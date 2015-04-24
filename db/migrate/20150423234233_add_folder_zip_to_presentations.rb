class AddFolderZipToPresentations < ActiveRecord::Migration
  def change
    add_column :presentations, :folder_zip, :string
  end
end
