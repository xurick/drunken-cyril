class RenameDatabaseColumn < ActiveRecord::Migration
  def change
    rename_column :sites, :logo_img_url, :logo_img
  end
end
