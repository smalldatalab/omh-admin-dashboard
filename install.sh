# sudo visudo
# mcarroll ALL=(ALL) NOPASSWD: ALL

sudo apt-get -y update;
sudo apt-get -y upgrade;
sudo apt-get -y install git-core;
sudo apt-get -y install python-software-properties;
sudo apt-get -y install build-essential openssl libssl-dev libreadline6 libreadline6-dev curl zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison libpcre3-dev nodejs openjdk-6-jre;

# POSTGRES
# sudo nano /etc/apt/sources.list.d/pgdg.list;
# # Add line: deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main
# wget https://www.postgresql.org/media/keys/ACCC4CF8.asc;
# sudo apt-key add ACCC4CF8.asc;
# sudo apt-get -y update;
# sudo apt-get -y install postgresql-9.4;
sudo apt-get -y install libpq-dev;

# 1. Install: sudo apt-get install postgresql  In addition to installing the Postgres server, this command will also create a new Linux user called "postgres", which is the superuser for managing Postgres server.
# 2. Become postgres:  sudo su postgres
# 3. Connect to Postgres server: psql
# 4. Create a new DB and a new user: CREATE DATABASE foodfido_production; CREATE USER mcarroll WITH PASSWORD 'myPassword';
# 5. Grant Permission to the new user: GRANT ALL PRIVILEGES ON DATABASE foodfido_production to mcarroll;
# 4. \q and then exit to go back to the original user
# 5. Connect to the new database as the new user: psql -h localhost -W tom -d jerry

# NGINX
# sudo add-apt-repository ppa:nginx/stable;
# sudo apt-get -y update;
# sudo apt-get -y install nginx;

# NTP
sudo apt-get -y install ntp;

# IMAGEMAGICK
# sudo apt-get -y install imagemagick libmagickwand-dev;

# RBENV
cd;
git clone git://github.com/sstephenson/rbenv.git .rbenv;
touch ~/.bash_profile;
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile;
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile;
source ~/.bash_profile;

# RUBY
mkdir -p ~/.rbenv/plugins;
cd ~/.rbenv/plugins;
git clone git://github.com/sstephenson/ruby-build.git;
rbenv install 2.1.5;
rbenv rehash;
rbenv global 2.1.5;
rbenv rehash;
gem install bundler --no-ri --no-rdoc;
rbenv rehash;

# Get to know github
ssh git@github.com;
