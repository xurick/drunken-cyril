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
  gem 'debugger', '~> 1.2.2'
end

# moving bootstrap out of :assets group in order to faciliate
# production live compiling
gem 'bootstrap-sass', '~> 2.2.1.1'
gem "spinjs-rails", "~> 0.0.4"

group :assets do
  gem 'bootswatch-rails', '~> 0.1.0'
  gem 'sass-rails',   '~> 3.2.5'
  gem 'uglifier', '~> 1.3.0'
end

gem 'jquery-rails', '~> 2.1.3'
gem 'jquery_mobile_rails', '~> 1.2.0'
gem 'miro', '~> 0.2.2'
gem 'fastimage', '1.2.13'
gem 'font-awesome-sass-rails', '~> 2.0.0.0'
gem 'rmagick', '~> 2.13.1'
gem "simple_form", "~> 2.0.2"
gem "validates_as_phone_number", "~> 0.7.5"
#gem "mercury-rails", :path => '/Users/budwhite/repo/mercury'
gem 'mercury-rails', :git => 'git://github.com/budwhite/mercury.git'

group :production do
  gem 'pg', '0.12.2'
end
gem 'paperclip'
