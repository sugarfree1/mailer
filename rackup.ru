# You can install Rack middlewares
# to do some crazy stuff like logging,
# filtering, auth or build your own.
use Rack::CommonLogger

require './child'
run Sinatra::Application