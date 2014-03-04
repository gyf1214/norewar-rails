namespace :unicorn do
	desc 'Start unicorn server'
	task :start do
		sh 'bundle exec unicorn -D -c config/unicorn.rb -E development'
	end
	desc 'Stop unicorn server'
	task :stop do
		pid = File.read('tmp/pids/unicorn.pid').to_i
		sh "kill -9 #{pid}"
		sh 'rm tmp/pids/unicorn.pid'
	end
end