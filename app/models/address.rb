class Address < ActiveRecord::Base
  attr_accessible :city, :state, :street1, :street2, :zipcode
  belongs_to :user

  VALID_ZIP_REGEX = /^\d{5}(-\d{4})?$/

  validates :user_id, :street1, :city, :state, :zipcode, presence: true

  # http://stackoverflow.com/questions/8212378/validate-us-zip-code-using-rails
  validates :zipcode, format: { :with => VALID_ZIP_REGEX, :message => 'should be in the form 12345 or 12345-1234' }

end
