require 'rubygems'
require 'bundler/setup'

require 'dotenv'
APP_ENV=ENV["APP_ENV"] || 'development'
Dotenv.load(
    File.expand_path(".#{APP_ENV}.env"),
    File.expand_path(".env") )


require 'yaml'
require 'logger'
require 'slack-notify'

LOGGER = Logger.new(STDERR)

class HerokuSlack
  def initialize
    @client = SlackNotify::Client.new(
      webhook_url: ENV['SLACK_WEBHOOK_URL'],
      channel: "#autonotifications",
      username: "martinosis",
      icon_emoji: ":shipit:",
      link_names: 1
    )
  end

  def call(env)
    req = Rack::Request.new(env)
    params = req.params
    notify_slack(params)
    ['200', {'Content-Type' => 'text/plain'}, [req.to_yaml + "\n" + params.to_yaml]]
  end

  def log(env)
    req = Rack::Request.new(env)
    params = req.params
    notify_slack
    LOGGER.info("Params: #{params.to_yaml}")
    LOGGER.info("ENV: #{env.to_yaml}")
  end

  def notify_slack(params)
    @client.notify(params.to_yaml)
  end
end

run Rack::URLMap.new(
  '/_deploy' => Rack::CommonLogger.new(HerokuSlack.new, LOGGER) 
)
