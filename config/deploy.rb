require 'capistrano/ext/multistage'
require 'capistrano_colors'
require 'bundler/capistrano'

def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

set :application, "sdl_admin_dashboard"
set :repository, "git@github.com:JudyWu/sdl_admin_dashboard.git"
set :stages, %w(production)
set :use_sudo, false
set :deploy_via, :remote_cache
set :keep_releases, 2
set :assets_dependencies, %w(app/assets vendor/assets)
set :whenever_environment, defer { stage }

set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

ssh_options[:forward_agent] = true

after "deploy:setup", "deploy:config"
after "deploy:config", "nginx:restart"
after "deploy:update_code", "deploy:symlink_secrets"
after "deploy:symlink_secrets", "bundle:install"
after "deploy:initialize_secrets", "deploy:upload_secrets"

namespace :deploy do
  desc "Deploy"
  task :default do
    update
    # crontab.install
    assets.precompile
    foreman.restart
    cleanup
    # memcached.restart
  end

  desc "Deploy with out assets rsync"
  task :skip_precompile do
    update
    # crontab.install
    foreman.restart
    cleanup
    # memcached.restart
  end

  desc "Setup a GitHub-style deployment."
  task :setup, except: { no_release: true } do
    run "git clone #{repository} #{current_path};"
    run "cd #{current_path}; git fetch origin; git reset --hard origin/#{branch}"
    initialize_secrets
  end

  desc "Update the deployed code."
  task :update_code, except: { no_release: true } do
    run "cd #{current_path}; git fetch origin; git reset --hard origin/#{branch}"
  end

  task :config do
    export
    upload_secrets
    bundle.install
    foreman.export
    # nginx.config
    # memcached.install
    # memcached.config
    run "mkdir -p #{current_path}/public/assets"
  end

  task :cleanup do
    logger.info "Nothing to cleanup!"
  end

  task :create_symlink do
    logger.info "Nothing to symlink!"
  end

  task :symlink_secrets do
    run "ln -nfs #{shared_path}/config/secrets.yml #{current_path}/config/secrets.yml;"
    logger.info "Secrets file has been symlinked!"
  end

  task :upload_secrets do
    servers = find_servers roles: [:app, :worker], except: { no_release: true }
    servers.each do |s|
      run_locally("rsync -av ./config/secrets.yml #{user}@#{s}:#{shared_path}/config/secrets.yml;")
    end
  end

  task :initialize_secrets do
    servers = find_servers roles: [:app, :worker], except: { no_release: true }
    servers.each do |s|
      run "mkdir -p #{shared_path}/config"
    end
  end

  task :export do
    run %{sudo bash -c 'echo "export RAILS_ENV=#{rails_env}" >> /etc/profile'}
  end
end

namespace :foreman do
  task :export do
    run "cd #{current_path}; sudo env PATH=$PATH bundle exec foreman export upstart /etc/init --user #{user} --app #{application} --log /var/log/#{application} -f Procfile.#{rails_env}"
  end

  task :restart do
    restart_web
    restart_worker
  end

  task :start do
    start_web
    start_worker
    # start_search
  end

  task :stop do
    stop_web
    stop_worker
    # stop_search
  end

  %w[web worker search].each do |role|
    %w[start stop restart].each do |command|
      desc "#{role} upstart #{command}"
      task "#{command}_#{role}", roles: role.to_sym do
        run "sudo #{command} #{application}-#{role}"
      end
    end
  end
end

namespace :nginx do
  %w[start stop restart].each do |command|
    desc "#{command} nginx"
    task command, roles: :app do
      run "sudo /etc/init.d/nginx #{command}"
    end
  end

  # task :config, roles: :app do
  #   template "nginx.erb", "/tmp/nginx.conf"
  #   run "mkdir -p #{deploy_to}/tmp"
  #   run "#{sudo} mv /tmp/nginx.conf /etc/nginx/sites-enabled/#{application}.conf"
  #   run "mkdir -p /home/#{user}/www; touch /home/#{user}/www/index.html"
  # end
end

namespace :bundle do
  desc 'Install gems'
  task :install, except: {no_release: true} do
    bundle_cmd     = fetch(:bundle_cmd, 'bundle')
    bundle_flags   = fetch(:bundle_flags, '--deployment')
    bundle_without = [*fetch(:bundle_without, [:development, :test])].compact
    args           = [bundle_flags.to_s, "--quiet"]
    args << "--without #{bundle_without.join(' ')}" unless bundle_without.empty?
    run "cd #{current_path} && #{bundle_cmd} install #{args.join(' ')}; rbenv rehash;"
  end
end

namespace :deploy do
  desc 'Deploy & migrate'
  task :migrations do
    update
    # crontab.install
    migrate
    assets.precompile
    foreman.restart
    cleanup
    # memcached.restart
  end

  desc 'Run migrations'
  task :migrate, roles: :db, only: { primary: true } do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake db:migrate"
  end

  desc 'Seed the DB'
  task :seed, roles: :db, only: { primary: true } do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake db:seed"
  end
end

namespace :assets do
  task :precompile, only: { primary: true } do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake assets:precompile;"
    # run_locally("mkdir -p public/__assets")
    # run_locally("mv public/__assets public/assets")
    # run_locally("RAILS_ENV=#{rails_env} bundle exec rake assets:precompile;")
    # servers = find_servers roles: [:app, :worker], except: { no_release: true }
    # servers.each do |s|
    #   run_locally("rsync -av ./public/assets/ #{user}@#{s}:#{current_path}/public/assets/;")
    # end
    # run_locally("mv public/assets public/__assets")
  end
end

namespace :memcached do
  # task :install, roles: :cache do
  #   run "#{sudo} apt-get -y install memcached"
  # end

  # task :config, roles: :cache do
  #   template "memcached.conf.erb", "/tmp/memcached.conf"
  #   run "#{sudo} mv /tmp/memcached.conf /etc/memcached.conf"
  # end

  # %w[start stop restart].each do |command|
  #   desc "#{command} memcached"
  #   task command, roles: :cache do
  #     run "sudo service memcached #{command}"
  #   end
  # end
end

namespace :crontab do
  # task :install do
  #   install_web
  # end

  # desc "Install crontab"
  # %w[web].each do |role|
  #   task "install_#{role}", roles: role.to_sym do
  #     run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec whenever --update-crontab #{application}"
  #   end
  # end
end
