require 'colorize'

class MasterProcessLogger
	def started(pid)
		puts "[Master]: child process (%s) started".green % [pid] 
	end

	def terminated(pid)
		puts "[Master]: child process (%s) terminated".red % [pid]
	end
end

class MailThreadLogger
	def fail(id, detail)
		puts "[Thread %s] FAIL. %s.".red % [Thread.current[:id], detail]
	end
end
