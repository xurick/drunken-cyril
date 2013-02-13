class ChangeDataTypeForSiteLogoImg < ActiveRecord::Migration
  def change
    change_column :sites, :logo_img, :text, :limit => nil
  end
end
