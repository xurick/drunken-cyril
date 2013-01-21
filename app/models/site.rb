class Site < ActiveRecord::Base
  attr_accessible :content, :logo_img, :nav_menu, :url, :subdomain, :phone, :theme, :snippet
  serialize :nav_menu

  before_save { |site| site.subdomain = subdomain.downcase }

  has_many :addresses, dependent: :destroy

  belongs_to :user

  validates :subdomain, presence: true, uniqueness: { case_sensitive: false }
end
