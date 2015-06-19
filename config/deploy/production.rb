server = '*'
user = '**'
role :app, server

set :password, ask('Server password', nil)

set :domain, server
set :server_name, server
server server, user: user, roles: %w{app}, password: fetch(:password), primary: true # , my_property: :my_value

set :use_sudo, false

set :rails_env, :production

set :migrate_env,    ""
set :migrate_target, :latest
