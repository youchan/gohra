require 'slack-ruby-client'

class SlackInterface
  def initialize(channel)
    @client = SlackInterface.connect
    @channel = @client.web_client.channels_join(name: channel)['channel']

    users_hash = users.map {|user| [user.id, user]}.to_h

    @client.on :message do |data|
      users_hash[data['user']].push(data['text']) if users_hash.has_key? data['user']
    end
  end

  def self.connect
    return @client if @client

    Slack.configure do |config|
      config.token = open(__dir__ + '/.access_token').read.strip
    end

    @client = Slack::RealTime::Client.new.tap do |client|
      client.web_client.auth_test
    end
  end

  def start
    @client.start!
  end

  def users
    @users ||= @channel['members'].map do |id|
      User.new(@client, @client.web_client.users_info(user: id)['user'])
    end
  end

  class User
    attr_reader :id, :name

    def initialize(client, user)
      @client = client
      @id = user['id']
      @name = user['name']
      @queue = Queue.new
      @channel = @client.web_client.im_open(user: @id)['channel']
      @client.web_client.channels_join(name: @id)['channel']
    end

    def puts(str)
      @client.web_client.chat_postMessage channel: @id, text: str, username: 'ghora_bot'
    end

    def input
      @queue.clear
      @queue.pop
    end

    def push(text)
      @queue.push text
    end
  end
end
