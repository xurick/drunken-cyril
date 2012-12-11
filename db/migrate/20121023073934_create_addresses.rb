class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :zipcode
      t.integer :user_id

      t.timestamps
    end
    # expect to retrieve all addresses associated with a given user id
    add_index :addresses, :user_id
  end
end
