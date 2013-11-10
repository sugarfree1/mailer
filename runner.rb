require 'optparse'
require 'ostruct'
require './master'

class ParseOptions
	def self.parse(args)
		options = OpenStruct.new
		options.size = 10
		options.port = 8000

		parser = OptionParser.new do |opts|
			opts.separator ""
			opts.separator "Optional arguments"

			opts.on("-p", "--port [PORT]", Integer, "Specify port for HTTPServer. By default: 8000") do |n|
				options.port = n
			end

			opts.on("-s", "--size [SIZE]", Integer, "Thread pool size for sending mail threads. By default: 10. Max: 20") do |n|
				options.size = n
			end

			opts.on_tail("-h", "--help", "Help") do
				puts opts
				exit
			end
		end

		parser.parse!(args)
		options
	end
end

begin 
	options = ParseOptions.parse(ARGV)
	master_process_controller = MasterProcessController.new
	master_process_controller.run(thread_pool_size=options.size, port=options.port)
rescue OptionParser::InvalidOption => e
	puts e
end