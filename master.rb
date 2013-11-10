require './loggers'

class MasterProcessController
	def initialize
		@logger = MasterProcessLogger.new
	end

	def run(thread_pool_size, port)

		pid = run_child(thread_pool_size, port)
		@logger.started(pid)

		while true do
			trap("INT") { terminate_child(pid); exit() }
			sleep(3)
			if not is_child_running?(pid)
				@logger.terminated(pid)
				pid = run_child(thread_pool_size, port)
				@logger.started(pid)
			end
		end
	end

	private

	def run_child(thread_pool_size, port)
		spawn("ruby -r './child.rb' -e 'run(%s, %s)'" % [thread_pool_size.to_s, port.to_s])
	end

	def terminate_child(pid)
		begin
			Process.kill("INT", pid)
			Process.waitpid(pid)
			@logger.terminated(pid)
		rescue Errno::ESRCH
		end
	end

	def is_child_running?(pid)
		begin
			Process.waitpid(pid, Process::WNOHANG) == nil
		rescue Errno::ECHILD => e
			false
		end
	end

end

