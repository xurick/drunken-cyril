class AddSnippetToSites < ActiveRecord::Migration
  def change
    add_column :sites, :snippet, :string
  end
end
