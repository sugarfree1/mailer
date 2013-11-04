require 'rubygems'
require 'sinatra'
require 'json'
require 'thin'
require 'pony'
require './thread_pool'
require './settings'

def run(pool_size, port="8000")
	$tp = ThreadPool.new(pool_size)
	Thin::Runner.new(["--port", port, "--address", "localhost", "--rackup", "rackup.ru", "start"]).run!
end

post '/mail' do
	@json = JSON.parse(request.body.read)
	$tp.schedule do
		Pony.mail(:to => @json["to"], 
			:from => EMAIL_CREDENTIALS["from"],
			:via => :smtp, 
			:via_options => {
				:address => EMAIL_CREDENTIALS["address"],
				:port => EMAIL_CREDENTIALS["port"],
				:user_name => EMAIL_CREDENTIALS["user_name"],
				:password => EMAIL_CREDENTIALS["password"]
				},
			:subject => @json["subject"],
			:body => @json["body"])
	end
end