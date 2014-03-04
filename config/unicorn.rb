root = File.expand_path('../..', __FILE__)
working_directory root
pid File.expand_path('tmp/pids/unicorn.pid', root)
stderr_path File.expand_path('log/unicorn.log', root)
stdout_path File.expand_path('log/unicorn.log', root)

listen 3000
worker_processes 2
timeout 30