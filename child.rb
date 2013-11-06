require 'rubygems'
require 'sinatra'
require 'json'
require 'thin'
require 'pony'
require 'colorize'
require './thread_pool'
require './settings'
require './mail'

def run(pool_size, port="8000")
	$tp = ThreadPool.new(pool_size)
	Thin::Runner.new(["--port", port, "--address", "localhost", "--rackup", "rackup.ru", "start"]).run!
end

post '/mail' do
	@json = JSON.parse(request.body.read)
	$tp.schedule do
		send_mail(EMAIL_CREDENTIALS, @json)
	end
end

def send_mail(credentials, data)

	begin
		mail_credentials = MailCredentials.new(credentials)
		Pony.mail(:to => @json.has_key?("to") ? @json["to"] : raise('No mail recipient.'), 
			:from => mail_credentials.from,
			:via => :smtp, 
			:via_options => {
				:address => mail_credentials.address,
				:port => mail_credentials.port,
				:user_name => mail_credentials.user_name,
				:password => mail_credentials.password,
				:authentication => mail_credentials.authentication,
				:enable_starttls_auto => mail_credentials.use_tls
				},
			:subject => @json.has_key?("subject") ? @json["subject"] : "",
			:body => @json.has_key?("body") ? @json["body"] : "" )

	rescue TimeoutError => e
		puts "[Thread %s] FAIL. Connection timeout.".red % [Thread.current[:id]]

	rescue IOError => e
		puts "[Thread %s] FAIL. IOError.".red % [Thread.current[:id]]

	rescue Exception => e
		puts "[Thread %s] FAIL. %s".red % [Thread.current[:id], e.message]
	end

end

