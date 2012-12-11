class BusinessHour < ActiveRecord::Base
  attr_accessible :close_time, :closed, :day_of_week, :open_time
  belongs_to :user

  validates :user_id, :day_of_week, :close_time, :open_time, presence: true
  validates :day_of_week, :inclusion => { :in => %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday), :message => "Not a valid week day name" }
  validates :closed, :inclusion => { :in => [true, false] }
end
