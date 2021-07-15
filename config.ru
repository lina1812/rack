require_relative 'middlewear/runtime'
require_relative 'middlewear/logger'
require_relative 'app'

use Runtime
use AppLogger, logdev: File.expand_path('log/app.log', __dir__)
run App.new
