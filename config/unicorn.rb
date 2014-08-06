app_path = File.expand_path(File.join(File.dirname(__FILE__), '..'))

if ENV['RACK_ENV'] == 'production'
  worker_processes 4
else
  worker_processes 2
end

timeout 120

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true

working_directory app_path
shared_directory = File.expand_path(File.join(app_path, '..', 'shared'))

listen "#{shared_directory}/sockets/unicorn.sock", :backlog => 64
pid "#{shared_directory}/pids/unicorn.pid"

stderr_path 'log/unicorn.stderr.log'
stdout_path 'log/unicorn.stdout.log'

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord)
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end
 
after_fork do |server, worker|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end