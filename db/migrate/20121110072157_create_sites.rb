class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.integer :user_id
      t.string :url
      t.string :logo_img_url
      t.string :nav_menu
      t.text :content

      t.timestamps
    end
    add_index :sites, :user_id
  end
end
