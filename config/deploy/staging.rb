server "lifestreams.smalldata.io", :web, :app, :worker, :db, :cache, primary: true

set (:user) { "michael" }
set (:application) { "sdl_admin_dashboard" }
set (:deploy_to) { "/home/#{user}/#{application}" }
set (:deploy_env) { 'staging' }
set (:rails_env) { 'staging' }
set (:branch) { 'staging' }
set (:thin_servers) { 1 }
set (:nginx_server) { "sandbox.gopushcart.com" }
set (:memcached_mem_limit) { 128 }