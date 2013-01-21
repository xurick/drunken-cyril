class AddIndexToSitesSubdomain < ActiveRecord::Migration
  def change
    add_index :sites, :subdomain, unique: true
  end
end
