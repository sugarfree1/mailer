require 'rubygems'
require 'sinatra'
require 'json'
require 'thin'
require 'pony'
require 'colorize'
require './thread_pool'
require './settings'
require './mailer'

def run(pool_size, port="8000")
	$tp = ThreadPool.new(pool_size)
	Thin::Runner.new(["--port", port, "--address", "localhost", "--rackup", "rackup.ru", "start"]).run!
end

post '/mail' do
	@json = JSON.parse(request.body.read)
	$tp.schedule do
		mailer = Mailer.new(EMAIL_CREDENTIALS)
		mailer.send(@json)
	end
end



