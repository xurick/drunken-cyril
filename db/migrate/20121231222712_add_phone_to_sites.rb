class AddPhoneToSites < ActiveRecord::Migration
  def change
    add_column :sites, :phone, :string
  end
end
