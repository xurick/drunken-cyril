class Site < ActiveRecord::Base
  attr_accessible :content, :logo_img, :nav_menu, :url, :subdomain
  serialize :nav_menu

  belongs_to :user
end
