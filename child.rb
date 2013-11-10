require 'rubygems'
require 'sinatra'
require 'json'
require 'thin'
require 'pony'
require 'colorize'
require './thread_pool'
require './mailer'
require './loggers'


def run(pool_size, port=8000)
	$thread_pool = ThreadPool.new(pool_size)
	logger = ChildProcessLogger.new
	begin
		Mailer.instance # raise error if credentials are not full
	rescue CredentialError => e
		logger.fail(e.message)
		exit
	end
	Thin::Runner.new(["--port", port.to_s, "--address", "localhost", "--rackup", "rackup.ru", "start"]).run!
end

post '/mail' do
	data = JSON.parse(request.body.read)
	$thread_pool.schedule do
		Mailer.instance.send(data)
	end
end



