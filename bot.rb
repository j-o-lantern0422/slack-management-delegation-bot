require 'slack-ruby-bot'
require 'dotenv'
require 'yaml'

require 'logger'

require_relative './libs/invite.rb'

require 'pry'

class PongBot < SlackRubyBot::Bot
  Dotenv.load
  @config = YAML.load_file("./config.yaml")
  log_level = @config['logger']['level'].to_sym
  @log = Logger.new("#{@config['logger']['log_dir']}/slack-mentainer.log", 'daily', level: log_level)
  @invite = SlackInvite.new

  Slack.configure do |config|
    config.token = ENV['SLACK_API_TOKEN']
  end
  @slack_client = Slack::Web::Client.new

  command 'ping' do |client, data, match|
    client.say(text: 'pong', channel: data.channel)
  end

  command 'invite' do | client, data, match |
    client.say(text: "#{data}", channel: data.channel)
    username = @slack_client.users_info(user: data.user)[:user][:name]
    log = "called invite command from #{username}. command: #{data.text}"
    @log.info(log)
  end
  
  command 'string with spaces', /some\s*regex+\?*/ do |client, data, match|
    client.say(channel: data.channel, text: match['command'])
  end
end

PongBot.run