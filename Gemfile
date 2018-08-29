source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.0'

gem 'rails', '~> 5.2.0'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'redis', '~> 4.0'
gem 'bootsnap', '>= 1.1.0', require: false

gem 'rack-cors', :require => 'rack/cors'
gem 'dotenv-rails', groups: [:development, :test]
gem 'bcrypt'
gem 'jwt'

gem 'simple_command'

gem 'apipie-rails'

gem 'active_model_serializers'
gem 'traceroute'

gem "figaro"
gem 'koala'

gem 'sidekiq'
gem 'foreman'

gem 'mime-types'
gem 'mini_magick'
# gem 'rmagick'
gem 'carrierwave', '~> 1.0'
gem 'carrierwave-video'
gem 'carrierwave-video-thumbnailer'
gem 'carrierwave-ffmpeg'
gem 'fog-aws'
gem "fog"
gem 'carrierwave_direct'


gem 'houston'

gem 'net-http2'
gem "awesome_print", require:'ap'

gem 'stripe'

gem 'oauth2'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'google-api-client'
gem 'rest-client'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

   # Remove the following if your app does not use Rails
  gem 'capistrano',         require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  # gem 'capistrano-rvm',     require: false
  gem 'capistrano-rbenv', require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano3-puma',   require: false
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
