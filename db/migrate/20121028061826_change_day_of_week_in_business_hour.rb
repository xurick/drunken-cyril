class ChangeDayOfWeekInBusinessHour < ActiveRecord::Migration
  def change
    change_column :business_hours, :day_of_week, :string
  end
end
