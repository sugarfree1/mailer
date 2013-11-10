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
	$tp = ThreadPool.new(pool_size)
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
	@json = JSON.parse(request.body.read)
	$tp.schedule do
		Mailer.instance.send(@json)
	end
end



