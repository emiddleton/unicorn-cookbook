default[:unicorn][:worker_timeout] = 60
default[:unicorn][:preload_app] = false
default[:unicorn][:worker_processes] = [node[:cpu][:total].to_i * 4, 8].min
default[:unicorn][:preload_app] = false
default[:unicorn][:before_fork] = 'sleep 1' 
default[:unicorn][:port] = '8080'
