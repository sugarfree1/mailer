require 'rubygems'
require 'sinatra'
require 'json'
require 'thin'
require 'pony'
require 'colorize'
require './thread_pool'
require './mailer'

def run(pool_size, port=8000)
	$tp = ThreadPool.new(pool_size)
	Mailer.instance # raise error if credentials are not full
	Thin::Runner.new(["--port", port.to_s, "--address", "localhost", "--rackup", "rackup.ru", "start"]).run!
end

post '/mail' do
	@json = JSON.parse(request.body.read)
	$tp.schedule do
		Mailer.instance.send(@json)
	end
end



