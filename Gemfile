# Gotta version the gems:
# http://blog.agoragames.com/blog/2010/11/30/to-version-or-not-to-version-your-gems-in-gemfiles/
# ruby gem versioning operators: ~>, => etc. 
# http://docs.rubygems.org/read/chapter/16#page76

source 'https://rubygems.org'

gem 'rails', '~> 3.2.9'
gem 'thin', '~> 1.5.0'
gem 'bcrypt-ruby', '~> 3.0.1'

group :development, :test do
  gem 'sqlite3', '~> 1.3.6'
end

group :assets do
  gem 'bootstrap-sass', '~> 2.2.1.1'
  gem 'bootswatch-rails', '~> 0.1.0'
  gem 'sass-rails',   '~> 3.2.5'
  gem 'uglifier', '~> 1.3.0'
end

gem 'win32console', :platforms => :mingw

gem 'jquery-rails', '~> 2.1.3'
gem 'jquery_mobile_rails', '~> 1.2.0'
gem "cocaine", "0.3.2"
gem 'miro', :git => 'git://github.com/rickkoh/miro.git'
gem 'fastimage', '1.2.13'
gem 'font-awesome-sass-rails', '~> 2.0.0.0'
gem 'rmagick', '~> 2.13.1'
gem "devise", "~> 2.1.2"
gem "cancan", "~> 1.6.8"
gem "rolify", "~> 3.2.0"
gem "hominid", "~> 3.0.5"
gem "google_visualr", "~> 2.1.3"
gem "jquery-datatables-rails", "~> 1.11.0"
gem "simple_form", "~> 2.0.2"
gem "validates_as_phone_number", "~> 0.7.5"
#gem "mercury-rails", "~> 0.9.0"

group :production do
  gem 'pg', '0.12.2'
end
