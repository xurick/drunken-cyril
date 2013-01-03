class Site < ActiveRecord::Base
  attr_accessible :content, :logo_img, :nav_menu, :url, :subdomain, :phone, :theme
  serialize :nav_menu

  has_many :addresses, dependent: :destroy

  belongs_to :user
end
