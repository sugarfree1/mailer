require './loggers'

def run_child(thread_pool_size, port)
	spawn("ruby -r './child.rb' -e 'run(%s, %s)'" % [thread_pool_size.to_s, port.to_s])
end

def terminate_child(pid)
	Process.kill("INT", pid)
	Process.waitpid(pid)
end

def is_running?(pid)
	begin
		Process.waitpid(pid, Process::WNOHANG) == nil
	rescue Errno::ECHILD => e
		false
	end
end

def run(thread_pool_size, port)
	master_logger = MasterProcessLogger.new

	pid = run_child(thread_pool_size, port)
	master_logger.started(pid)

	while true do
		trap("INT") { terminate_child(pid); exit() }
		sleep(3)
		if not is_running?(pid)
			master_logger.terminated(pid)
			pid = run_child(thread_pool_size, port)
			master_logger.started(pid)
		end
	end
end


