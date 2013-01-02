class RenameUserIdToSiteId < ActiveRecord::Migration
  def up
    rename_column :addresses, :user_id, :site_id
  end

  def down
    rename_column :addresses, :site_id, :user_id
  end
end
