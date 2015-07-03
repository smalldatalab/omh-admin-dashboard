server "ohmage-omh.smalldata.io", :web, :app, :worker, :db, :cache, primary: true

set (:user) { "admin_dashboard" }
set (:application) { "admindashboard" }
set (:deploy_to) { "/home/#{user}/#{application}" }
set (:deploy_env) { 'production' }
set (:rails_env) { 'production' }
set (:branch) { 'master' }
set (:thin_servers) { 1 }
set (:nginx_server) { "" }
set (:memcached_mem_limit) { 128 }