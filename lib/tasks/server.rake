namespace :server do
	desc 'Start the server'
	task :start => ['assets:precompile', 'unicorn:start', 'sidekiq:start']

	desc 'Stop the server'
	task :stop => ['unicorn:stop', 'sidekiq:stop']

	desc 'Restart the server'
	task :restart => [:stop, :start]
end