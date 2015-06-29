FROM ruby:2.1.5
MAINTAINER Jared Sieling <jared.sieling@gmail.com>

RUN apt-get -y update && apt-get -y install build-essential

# for postgres
RUN apt-get install -y libpq-dev

# for a JS runtime (ActiveAdmin requires)
RUN apt-get install -y nodejs

# don't know if this is needed??
RUN apt-get install -y ntp

RUN mkdir /sdl-admin-dashboard

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

ADD . /sdl-admin-dashboard
WORKDIR /sdl-admin-dashboard
RUN RAILS_ENV=production rake assets:precompile

EXPOSE 3000

CMD ["bash","docker-cmd.sh"]