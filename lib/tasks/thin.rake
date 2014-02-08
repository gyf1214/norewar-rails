namespace :thin do
	desc 'Start thin server'
	task :start do
		sh "thin start -d -Ptmp/pids/thin.pid"
	end
	desc 'Stop thin server'
	task :stop do
		sh "thin stop -f -Ptmp/pids/thin.pid"
	end
end