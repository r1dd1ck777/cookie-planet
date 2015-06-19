# config valid only for Capistrano 3.1
# lock '3.2.1'

set :application, 'vkusno'
set :repo_url, 'git@bitbucket.org:r1dd1ck777/vkusno.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call


# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_dirs, %w{tmp/pids tmp/sockets vendor/bundle log public/uploads public/assets public/system grabber_cache}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :tmp_dir, '/home/deployer/tmp'
set :deploy_to, '/home/deployer/production/vkusno'

# set :shared_children, ['public/system', 'log', 'tmp/pids']

set :preload_app, true
# set :assets_roles, :app
# set :migration_role, :app

namespace :deploy do

  after :publishing, :restart

  namespace :assets do
    before :precompile, :migrate
  end

  namespace :assets do
    before :precompile, :cp_db_yml do
      on roles(:app) do
        execute "rm -f #{release_path}/config/settings/production.local.yml"
        execute "ln -s #{release_path}/config/deploy/settings/#{fetch(:stage)}/production.local.yml #{release_path}/config/settings/production.local.yml"
      end
    end
  end
end
###

set :deploy_via, :remote_cache

# rvm
set :rvm_type, :users
set :rvm_ruby_version, '2.0.0'              # use the same ruby as used locally for deployment


