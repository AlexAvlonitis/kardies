require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/nginx'
require 'capistrano/puma'
install_plugin Capistrano::Puma
require 'capistrano/puma/nginx'
install_plugin Capistrano::Puma::Nginx
require 'capistrano/rbenv'
require 'capistrano/rails'
require 'capistrano/rails/db'
require 'capistrano/rails/console'
require 'capistrano/upload-config'
require 'sshkit/sudo'

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
