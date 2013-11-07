require 'singleton'
require 'colorize'
require './settings'

class Mailer
	include Singleton

	attr_reader :user_name
	attr_reader :password
	attr_reader :port
	attr_reader :address
	attr_reader :from
	attr_reader :authentication
	attr_reader :enable_starttls_auto
	attr_reader :use_tls

	def initialize()
		@credentials = EMAIL_CREDENTIALS

		@use_tls = get_credential("use_tls")
		@user_name = get_credential("user_name")
		@password = get_credential("password")
		@port = get_credential("port")
		@address = get_credential("address")
		@from = get_credential("from")

		@authentication = :plain
		if @use_tls
			@authentication = :cram_md5
		end
	end

	def send(data)

		begin
			Pony.mail(:to => data.has_key?("to") ? data["to"] : raise('No mail recipient.'), 
				:from => @from,
				:via => :smtp, 
				:via_options => {
					:address => @address,
					:port => @port,
					:user_name => @user_name,
					:password => @password,
					:authentication => @authentication,
					:enable_starttls_auto => @use_tls
					},
				:subject => data.has_key?("subject") ? data["subject"] : "",
				:body => data.has_key?("body") ? data["body"] : "" )

		rescue TimeoutError => e
			puts "[Thread %s] FAIL. Connection timeout.".red % [Thread.current[:id]]

		rescue IOError => e
			puts "[Thread %s] FAIL. IOError.".red % [Thread.current[:id]]

		rescue Exception => e
			puts "[Thread %s] FAIL. %s".red % [Thread.current[:id], e.message]
		end

	end

	private

	def get_credential(key)
		@credentials.has_key?(key) ? @credentials[key] : raise("Wrong user credentials. Missing '#{key}'.")
	end

end