class MailCredentials

	attr_reader :user_name
	attr_reader :password
	attr_reader :port
	attr_reader :address
	attr_reader :from
	attr_reader :authentication
	attr_reader :enable_starttls_auto
	attr_reader :use_tls

	def initialize(credentials)
		@credentials = credentials

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

	def get_credential(key)
		@credentials.has_key?(key) ? @credentials[key] : raise("Wrong user credentials. Missing '#{key}'.")
	end

end