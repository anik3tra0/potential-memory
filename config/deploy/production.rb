# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server "example.com", user: "deploy", roles: %w{app db web}, my_property: :my_value
# server "example.com", user: "deploy", roles: %w{app web}, other_property: :other_value
# server "db.example.com", user: "deploy", roles: %w{db}



# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

# role :app, %w{deploy@example.com}, my_property: :my_value
# role :web, %w{user1@primary.com user2@additional.com}, other_property: :other_value
# role :db,  %w{deploy@example.com}



# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.



# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# The server-based syntax can be used to override options:
# ------------------------------------
# server "example.com",
#   user: "user_name",
#   roles: %w{web app},
#   ssh_options: {
#     user: "user_name", # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: "please use keys"
#   }
#


# frozen_string_literal: true
server '139.59.89.94', user: 'deploy', roles: %w(web app db)

# Don't change these unless you know what you're doing
set :application,     'potential-memory'
set :pty,             false
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache #remote_cache takes the code from bitbucket, if set to local then it will pick from local machine
set :deploy_to,       "/home/#{fetch(:user)}/#{fetch(:stage)}/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa_sparkyo)
set :puma_preload_app, true
set :puma_threads,    [0, 16]
set :puma_workers,    1
set :puma_worker_timeout, nil
set :puma_init_active_record, true # Change to false when not using ActiveRecord
# set :deploytag_time_format, "%Y.%m.%d-%H%M%S-utc"
# set :deploytag_utc, false
# ask :deploytag_commit_message
# set :branch, ENV["REVISION"] || ENV["BRANCH_NAME"] || "master"
set :branch, proc { `git rev-parse --abbrev-ref master`.chomp }
set :keep_releases, 3
# set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }
# set :sidekiq_default_hooks, true
# set :sidekiq_pid, File.join(shared_path, 'tmp', 'pids', 'sidekiq.pid') # ensure this path exists in production before deploying.
# set :sidekiq_env, fetch(:rack_env, fetch(:rails_env, fetch(:stage)))
# set :sidekiq_log, File.join(shared_path, 'log', 'sidekiq.log')
# set :sidekiq_timeout, 10
# set :sidekiq_role, :app
# set :sidekiq_processes, 1

namespace :deploy do
    desc 'Make sure local git is in sync with remote.'
    task :check_revision do
        on roles(:app) do
            unless `git rev-parse HEAD` == `git rev-parse origin/master`
                puts 'WARNING: HEAD is not the same as origin/master'
                puts 'Run `git push` to sync changes.'
                exit
            end
        end
    end

    desc 'Initial Deploy'
    task :initial do
        on roles(:app) do
            before 'deploy:restart', 'puma:start'
            invoke 'deploy'
        end
    end

    # desc 'Seed Database'
    # task :seed do
    #     on roles(:app) do
    #         within current_path.to_s do
    #             with rails_env: fetch(:stage).to_s do
    #                 execute :rake, 'db:seed'
    #             end
    #         end
    #     end
    # end
    #
    # desc 'Setup Geography'
    # task :setup_geography do
    #     on roles(:app) do
    #         within current_path.to_s do
    #             with rails_env: fetch(:stage).to_s do
    #                 execute :rake, 'setup_geography'
    #             end
    #         end
    #     end
    # end
    #
    # desc 'Setup Task Templates'
    # task :setup_task_templates do
    #     on roles(:app) do
    #         within current_path.to_s do
    #             with rails_env: fetch(:stage).to_s do
    #                 execute :rake, 'setup_task_templates'
    #             end
    #         end
    #     end
    # end

    desc 'Restart application'
    task :restart do
        on roles(:app), in: :sequence, wait: 5 do
            invoke 'puma:restart'
        end
    end

    # desc 'Reindex Tenants'
    # task :reindex_tenants do
    #     on roles(:app) do
    #         within current_path.to_s do
    #             with rails_env: fetch(:stage).to_s do
    #                 execute :rake, 'searchkick:reindex_tenants'
    #             end
    #         end
    #     end
    # end

    before :starting,     :check_revision
    after  :finishing,    :compile_assets
    after  :finishing,    :cleanup
    after  :finishing,    :restart
    # after  :finishing,    :reindex_tenants
    # after  :initial,      :seed
    # after  :initial,      :setup_geography
    # after  :initial,      :setup_task_templates
end
