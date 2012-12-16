class User < ActiveRecord::Base
  # these attributes are updatable via update_attributes method
  attr_accessible :name, :email, :password, :password_confirmation, :phone_number, :addresses_attributes

  #has_secure_password

  # a user can have many addresses, which will be destroyed when the user is destroyed
  has_many :addresses, dependent: :destroy
  has_many :business_hours, dependent: :destroy

  has_many :sites, dependent: :destroy

  # allows for creating/updating of associated model inside the same form
  accepts_nested_attributes_for :addresses, :allow_destroy => true

  # tough one: allows for the user to add multiple objects within one form when each object 
  # already has an attribute defined (the day_of_week attr) 
  days_of_week = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday) 
  days_of_week.each do |day_of_week| 
    attribute = "#{day_of_week.downcase}_business_hours".to_sym 
    has_many attribute, :class_name => 'BusinessHour', :conditions => {:day_of_week => day_of_week} 
    accepts_nested_attributes_for attribute, :allow_destroy => true 
    attr_accessible (attribute.to_s + "_attributes").to_sym 
  end 

  # before_save is a callback that gets called before the record is saved to DB
  before_save :before_save_stuff

  # http://stackoverflow.com/questions/6101628/regex-to-validate-user-names-with-at-least-one-letter-and-no-special-characters
  # http://guides.rubyonrails.org/active_record_validations_callbacks.html
  VALID_NAME_REGEX = /^[a-zA-Z0-9_]*[a-zA-Z][a-zA-Z0-9_]*$/
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # make sure the name field must exist, and the length of it must
  # not exceed 51, when a new record is created etc.
  validates :name, presence: true, length: { maximum: 50 }, format: { with: VALID_NAME_REGEX }, unless: :guest?

  # to guarantee real uniqueness of email, need to create a DB index on the email column
  # and require that the index be unique
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true, unless: :guest?

  # http://stackoverflow.com/questions/8170422/attr-accessor-and-password-validation-on-update
  # the :if => :password part is to prevent validation from triggered for update
  #validates :password_digest, presence: true, unless: :guest?
  #validates :password, presence: true, length: { minimum: 6 }, :if => :password, unless: :guest?
  #validates :password_confirmation, presence: true, :if => :password_confirmation, unless: :guest?
  # https://github.com/travisjeffery/validates_phone_number
  validates_as_phone_number :phone_number, :message => 'Invalid phone number format', :allow_nil => true

  validates_presence_of :password_digest, unless: :guest?
  validates_confirmation_of :password

  # override has_secure_password to customize validation until Rails 4.
  require 'bcrypt'
  attr_reader :password
  include ActiveModel::SecurePassword::InstanceMethodsOnActivation

  def move_to(user)
    # note: this does not create a new 'sites' record, but mere update the foreign key
    # i.e. modify the association to be with the newly create user
    sites.update_all(user_id: user.id)
    addresses.update_all(user_id: user.id)
    business_hours.update_all(user_id: user.id)
  end

  private

  def self.new_guest
    new { |u| u.guest = true }
  end

  def before_save_stuff
    if !guest
      # downcasing email is to enforce uniqueness as well
      self.email = email.downcase
    end
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
