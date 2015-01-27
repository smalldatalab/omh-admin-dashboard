server "128.84.9.152", :web, :app, :worker, :db, :cache, primary: true

set (:user) { "mcarroll" }
set (:application) { "pushcart" }
set (:deploy_to) { "/home/#{user}/#{application}" }
set (:deploy_env) { 'production' }
set (:rails_env) { 'production' }
set (:branch) { 'master' }
set (:thin_servers) { 1 }
set (:nginx_server) { "gopushcart.com" }
set (:memcached_mem_limit) { 128 }