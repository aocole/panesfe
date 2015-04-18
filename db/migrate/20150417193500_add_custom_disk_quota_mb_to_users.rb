class AddCustomDiskQuotaMbToUsers < ActiveRecord::Migration
  def change
    add_column :users, :custom_disk_quota_mb, :integer
  end
end
