require_relative 'middlewear/runtime'
require_relative 'middlewear/logger'
require_relative 'time_app'

use Runtime
use AppLogger, logdev: File.expand_path('log/app.log', __dir__)

ROUTES = {
'/time' => TimeApp.new
}

run Rack::URLMap.new(ROUTES)
