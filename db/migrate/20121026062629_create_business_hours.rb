class CreateBusinessHours < ActiveRecord::Migration
  def change
    create_table :business_hours do |t|
      t.integer :user_id
      t.integer :day_of_week
      t.time :open_time
      t.time :close_time
      t.boolean :closed

      t.timestamps
    end
    # expect to retrieve all business hours information with a given user id
    add_index :business_hours, :user_id
  end
end
