require './environment'
require 'heroku_slack'

run Rack::URLMap.new(
  '/_deploy' => Rack::CommonLogger.new(HerokuSlack.new, LOGGER) 
)
