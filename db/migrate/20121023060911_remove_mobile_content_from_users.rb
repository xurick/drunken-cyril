class RemoveMobileContentFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :mobile_content
  end
end
