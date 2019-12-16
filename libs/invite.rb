require 'faraday'
require 'dotenv'

class Invite
  Dotenv.load(".env")
  SLACK_USER_INVITE_API="https://#{ENV["WORKSPACE"]}.slack.com/api/users.admin.invite"

  def initialize
    @conn = Faraday::Connection.new(url: SLACK_USER_INVITE_API) do |builder|
      builder.use Faraday::Request::UrlEncoded
      builder.use Faraday::Response::Logger
      builder.use Faraday::Adapter::NetHttp
    end
    @token = ENV["SLACK_LEGACY_API_TOKEN"]
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

    format!(response)
  end

  def format!(response)
    if JSON.parse(response.body)["ok"]
      return "invite successed!"
    else
      return "invite faild. response is #{response.body}"
    end

    "panic"
  end
end
