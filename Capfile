# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

# require 'capistrano/rails'
require 'capistrano/rails/migrations'
require 'capistrano/passenger'

# If you are using rbenv add these lines:
# require 'capistrano/rvm'
require 'capistrano/rbenv'
require "capistrano/bundler"
# require 'capistrano/npm'
# require 'capistrano/nvm'

# ----------------------------

set :user, 'deploy'
set :scm, :git
set :format, :pretty
set :log_level, :debug
set :pty, true
# set :nvm_custom_path, '/home/deploy/.nvm'
# set :nvm_type, :user # or :system, depends on your nvm setup
# set :nvm_node, 'v8.9.3'
# set :nvm_map_bins, %w{node npm}

# set :npm_target_path, -> { release_path.join('subdir') } # default not set
# set :npm_flags, '--production --silent --no-progress'    # default
# set :npm_roles, :all                                     # default
# set :npm_env_variables, {}                               # default

set :keep_releases, 5

# ----------------------------

# Load the SCM plugin appropriate to your project:
#
# require "capistrano/scm/hg"
# install_plugin Capistrano::SCM::Hg
# or
# require "capistrano/scm/svn"
# install_plugin Capistrano::SCM::Svn
# or
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger
#
# require "capistrano/rvm"
# require "capistrano/rbenv"
# require "capistrano/chruby"
# require "capistrano/bundler"
# require "capistrano/rails/assets"
# require "capistrano/rails/migrations"
# require "capistrano/passenger"

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }