class ChangeDataTypeForSiteNavMenu < ActiveRecord::Migration
  def change
    change_column :sites, :nav_menu, :text, :limit => nil
  end
end
