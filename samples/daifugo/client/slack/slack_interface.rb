require 'slack-ruby-client'


class SlackInterface
  def initialize(channel)
    @client = SlackInterface.connect
    @channel = @client.channels_join(name: channel)['channel']
  end

  def self.connect
    return @client if @client

    Slack.configure do |config|
      config.token = open(__dir__ + '/.access_token').read.strip
    end

    @client = Slack::Web::Client.new.tap do |client|
      client.auth_test
    end
  end

  def users
    @channel['members'].map do |id|
      User.new(@client, @client.users_info(user: id)['user'])
    end
  end

  class User
    def initialize(client, user)
      @client = client
      @id = user['id']
      @name = user['name']
      #@channel = @client.channels_join(name: @id)['channel']
    end

    def puts(str)
      @client.chat_postMessage channel: @id, text: str, username: 'ghora_bot'
    end
  end
end
