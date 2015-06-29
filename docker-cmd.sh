RAILS_ENV=production rake db:migrate;
RAILS_ENV=production rake jobs:work;
rails server;