require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/puma'
install_plugin Capistrano::Puma
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails/migrations'
require 'capistrano/rails/db'
require 'capistrano/rails/console'
require 'capistrano/upload-config'
require 'sshkit/sudo'

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
