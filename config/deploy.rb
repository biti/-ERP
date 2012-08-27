# encoding: utf-8

require 'bundler/capistrano'
require "whenever/capistrano"
require "rvm/capistrano"
set :rvm_ruby_string, 'ruby-1.9.3-p194'
set :assets_dependencies, %w(app/assets lib/assets vendor/assets Gemfile.lock config/routes.rb)

# set :rails_env, :development

set :user, "www"
set :application, "erp-dev"
set :repository,  "set your repository location here"

set :deploy_to, "/home/www/#{application}"

set :repository, "."
set :scm, :none
set :deploy_via, :copy

default_run_options[:pty] = true


role :web, "shijingshan1"                          # Your HTTP server, Apache/etc
role :app, "shijingshan1"                          # This may be the same as your `Web` server
role :db,  "shijingshan1", :primary => true        # This is where Rails migrations will run
role :db,  "shijingshan1"

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"  

set :unicorn_binary, "unicorn_rails"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"

puts "current_path=========%s" % [current_path]

namespace :deploy do
  
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && bundle exec #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
    run "kill `cat #{unicorn_pid}`"
  end

  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "kill -s QUIT `cat #{unicorn_pid}`"
  end

  task :reload, :roles => :app, :except => { :no_release => true } do
    run "kill -s USR2 `cat #{unicorn_pid}`"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end

  namespace :assets do

    desc <<-DESC
      Run the asset precompilation rake task. You can specify the full path \
      to the rake executable by setting the rake variable. You can also \
      specify additional environment variables to pass to rake via the \
      asset_env variable. The defaults are:

        set :rake, "rake"
        set :rails_env, "production"
        set :asset_env, "RAILS_GROUPS=assets"
        set :assets_dependencies, fetch(:assets_dependencies) + %w(config/locales/js)
    DESC
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} #{assets_dependencies.join ' '} | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{​​rails_env} #{asset_env} assets:precompile}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end

  end

end
