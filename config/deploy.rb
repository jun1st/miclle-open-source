# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'macdesks'
set :repo_url, 'git@github.com:jun1st/miclle-open-source.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/jun1st/www/desksformac'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty
set :rbenv_ruby, '2.1.2'
# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/newrelic.yml config/config.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log pids sockets tmp/cache vendor/bundle}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  desc 'restart unicorn'
  task :restart do
    invoke 'unicorn:restart'
  end
  task :stop do
    invoke 'unicorn:stop'
  end

  task :start do
    invoke 'unicorn:start'
  end

  task :generate_sitemap do
    invoke 'sitemap:generate'
  end

end
