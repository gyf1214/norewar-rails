NoreWar-Rails
===============

An implement of NoreWar competition game on rails. See [SHSTuring/norewar](https://github.com/SHSTuring/norewar) for more infomation about NoreWar.

Requirements
--------------

I use Ruby 2.0.0p353 & Rails 4.0.2. Other versions is untested but Ruby 1.9.7 & Rails 4.0.2 are required at least.

[Mongo](http://www.mongodb.org) is required for database. I use version 2.4.5.

[Redis](http://redis.io) is required for cache. I tested with version 2.6.16. According to Sidekiq version 2.4 is required at least


Installation
--------------

Use Bundler to install all the gems required:

	bundle install

If you have not installed Bundler install it first:

	gem install bundler

Execution
-------------

Start [Mongo](http://www.mongodb.org) & [Redis](http://redis.io) fist.

[Thin](http://code.macournoyer.com/thin/) is used as the web server. Start with:

	bundle exec thin start

Start [Sidekiq](https://github.com/mperham/sidekiq) to process matches:

	bundle exec sidekiq

Problems
-------------

Please open an [issue](https://github.com/gyf1214/norewar-rails/issues).

Contribution
-------------

Please open a [PR](https://github.com/gyf1214/norewar-rails/pulls)

