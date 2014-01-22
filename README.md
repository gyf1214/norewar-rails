NoreWar-Rails
===============

An implement of NoreWar competition game on rails. See [SHSTuring/norewar](https://github.com/SHSTuring/norewar) for more information about NoreWar.

Requirements
--------------

I use Ruby 2.0.0p353 & Rails 4.0.2. Other versions is untested but Ruby 1.9.7 & Rails 4.0.2 are required at least.

[Mongo](http://www.mongodb.org) is required for database. I use version 2.4.5.

[Redis](http://redis.io) is required for cache. I tested with version 2.6.16. According to [Sidekiq](https://github.com/mperham/sidekiq) version 2.4 is required at least.


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

For thread safety of mongo, the pool size of working threads & mongo connections should be limited. For efficiency consideration, I set the connection pool size to 10 & thread pool size to 4. Check your config/mongo.yml for configuration and use the following command to start sidekiq: (which provide default configuration starting 25 threads!)
	
	# start 4 working threads
	bundle exec sidekiq -c 4

Problems
-------------

Please open an [issue](https://github.com/gyf1214/norewar-rails/issues).

Contribution
-------------

Please open a [PR](https://github.com/gyf1214/norewar-rails/pulls).

