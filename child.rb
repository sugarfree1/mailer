require 'rubygems'
require 'sinatra'
require 'json'
require 'thin'
require './thread_pool'

def run(pool_size, port="8000")
	$tp = ThreadPool.new(pool_size)
	Thin::Runner.new(["--port", port, "--address", "localhost", "--rackup", "rackup.ru", "start"]).run!
end

post '/mail' do 
	puts "mail"
	@json = JSON.parse(request.body.read)
	puts @json["text"]
	$tp.schedule do
		puts "Job started by thread #{Thread.current[:id]}"
		sleep rand(10) + 5
		puts "Job finished by thread #{Thread.current[:id]}"
	end
end