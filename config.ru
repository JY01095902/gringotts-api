$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'src', 'apis'))
require 'api'
require 'rack/cors'

use Rack::Cors do
    allow do
        origins '*'
        resource '*', headers: :any, methods: :get
    end
end

run API