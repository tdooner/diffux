# Diffux

[![Build Status](https://travis-ci.org/trotzig/diffux.png)](https://travis-ci.org/trotzig/diffux)
[![Code Climate](https://codeclimate.com/github/trotzig/diffux.png)](https://codeclimate.com/github/trotzig/diffux)
[![Coverage Status](https://coveralls.io/repos/trotzig/diffux/badge.png?branch=master)](https://coveralls.io/r/trotzig/diffux)
[![Dependency Status](https://gemnasium.com/trotzig/diffux.png)](https://gemnasium.com/trotzig/diffux)

Are you worried that your CSS changes will break the current design in
unexpected ways? Do you want to show a designer a page you've been working on,
before and after your changes? Do you want to be able to quickly look back at
how things looked a month or a year ago?

Diffux is a tool that generates and manages visual diffs of web pages, so that
you can easily see even the subtlest effects of your code modifications.

## Installing

Diffux requires:

- ImageMagick
- PostgreSQL
- Redis
- Ruby 2.0.0+

### Mac OS X (Using Homebrew)

Below are some example installation instructions that might help you get Diffux
up and running on Mac OS X using Homebrew.

```bash
# clone repo
git clone https://github.com/trotzig/diffux.git
cd diffux

# install dependencies
brew update
brew doctor
brew install imagemagick postgresql redis

# install gems
bundle install

# start postgres
pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start

# start redis
redis-server

# create tables, load the schema, and run migrations
bundle exec rake db:setup
```

## Running the server

Diffux is a [Rails] app, so if you are familiar with that web framework the
following should be fairly straightforward.

```bash
bundle exec rails s
```

[Rails] runs on port 3000 by default, so you should be able to fire up your
browser with the following URL:

```
http://localhost:3000
```

## Running a worker

Snapshot creation and comparing is handled asynchronously, through [Sidekiq]
workers. To start a worker, run:

```bash
bundle exec sidekiq
```

## Configuring OAuth login
In order to get login working with Google, you need to get an OAuth Client and
Secret key from Google. To do this:

1. Go to https://code.google.com/apis/console/
2. Create a new project
3. Go to "Credentials" under "APIs & Auth"
4. Click "Create New Client ID"
  * Set the "Authorized Javascript Origin" to your URL
  * Set "Authorized Redirect URI" to "https://[site]/auth/google_oauth2/callback"

These must be set to **GOOGLE_CLIENT_ID**, and **GOOGLE_CLIENT_SECRET**
environment variables. A good way to do this is put them as [key]=[value] pairs
in the `.env` file in this directory, and then use `foreman start` to start the
server and worker.

## Running Diffux on Heroku

Diffux can run on Heroku. In order to do this, you will need an Amazon Web
Services (AWS) S3 account to store the snapshots. You will need a "secret key"
and a "access key" from Amazon. Once you have those values, you're all set!
Follow these steps:

```bash
# clone repo
git clone https://github.com/trotzig/diffux.git
cd diffux

# create and configure the heroku application
heroku create [diffux] --buildpack https://github.com/ddollar/heroku-buildpack-multi.git
heroku addons:add heroku-postgresql
heroku addons:add rediscloud
heroku config:set \
  PHANTOMJS_PATH=/app/vendor/phantomjs/bin/phantomjs \
  AWS_SECRET_KEY=[secret-key] \
  AWS_ACCESS_KEY=[access-key]

# deploy!
git push heroku master

# initialize the database
heroku run rake db:migrate

# add a worker thread to take snapshots and generate compared images:
heroku ps:scale worker=1

# done! you should now be able to access your application at
# http://[diffux].herokuapp.com
```

## License

Released under the MIT License.

[Rails]: http://rubyonrails.org/
[Sidekiq]: http://sidekiq.org/
