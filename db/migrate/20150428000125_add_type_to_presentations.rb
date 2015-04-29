class AddTypeToPresentations < ActiveRecord::Migration
  def change
    add_column :presentations, :type, :string, null: false, default: 'Slideshow'
    rename_column :slides, :presentation_id, :slideshow_id
  end
end
