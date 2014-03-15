namespace :server do
	desc 'Start the server'
	task :start => ['assets:precompile', 'unicorn:start', 'sidekiq:start']

	desc 'Stop the server'
	task :stop => ['unicorn:stop', 'sidekiq:stop']

	desc 'Pull from github'
	task :pull do
		sh 'git pull'
	end

	desc 'Restart the server'
	task :restart => [:stop, :start]

	desc 'Refresh & restart the server'
	task :refresh => [:pull, :restart]
end