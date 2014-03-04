namespace :sidekiq do
	desc 'Start sidekiq server'
	task :start do
		sh 'bundle exec sidekiq -d -L log/sidekiq.log -P tmp/pids/sidekiq.pid'
	end
	desc 'Stop sidekiq server'
	task :stop do
		pid = File.read('tmp/pids/sidekiq.pid').to_i
		sh "kill #{pid}"
		sh 'rm tmp/pids/sidekiq.pid'
	end
end