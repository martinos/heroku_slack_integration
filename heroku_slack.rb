require 'yaml'
require 'slack-notify'

class HerokuSlack
  def initialize
    LOGGER.info("INIT")
    @client = SlackNotify::Client.new(
      webhook_url: ENV['SLACK_WEBHOOK_URL'],
      channel: "#autonotifications",
      username: "martinosis",
      icon_emoji: ":shipit:",
      link_names: 1
    )
    @gh_user = "martinos"
    @gh_project = "heroku_slack_integration"
  end

  def call(env)
    req = Rack::Request.new(env)
    params = req.params
    notify_slack(params)
    ['200', {'Content-Type' => 'text/plain'}, [req.to_yaml + "\n" + params.to_yaml]]
  end

  def html_diffs(new_sha)
    "https://github.com/#{@gh_user}/#{@gh_project}/compare/#{prev_sha}...#{new_sha}"
  end

  def store_sha(sha)
    Commit.create(sha: sha)
  end

  def prev_sha
    last = Commit.last
    LOGGER.info "\033[31mLastcommit#{last.inspect}\033[0m"
    last && last.sha
  end

  def log(env)
    req = Rack::Request.new(env)
    params = req.params
    LOGGER.info("Params: #{params.to_yaml}")
    LOGGER.info("ENV: #{env.to_yaml}")
  end

  def notify_slack(params)
    if sha = params["head"]
      if prev_sha
        params["diff"] = html_diffs(sha)
      end
      store_sha(sha)
    end
    @client.notify(params.to_yaml)
  end
end

