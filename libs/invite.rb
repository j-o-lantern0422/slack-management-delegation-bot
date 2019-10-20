require 'faraday'
require 'dotenv'

class SlackInvite
  Dotenv.load(".env")
  SLACK_USER_INVITE_API="https://#{ENV["WORKSPACE"]}.slack.com/api/users.admin.invite"

  def initialize
    @conn = Faraday::Connection.new(url: SLACK_USER_INVITE_API) do |builder|
      builder.use Faraday::Request::UrlEncoded
      builder.use Faraday::Response::Logger
      builder.use Faraday::Adapter::NetHttp
    end
    @token = ENV["SLACK_API_TOKEN"]
  end

  def invite(mail: , name: nil)
    response = @conn.post do | req |
      req.body = {
        email: mail,
        real_name: name,
        token: @token,
        set_active: true
      }
    end

    response
  end
end
