class RemoveSiteUrlFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :site_url
  end

  def down
    add_column :users, :site_url, :string
  end
end
