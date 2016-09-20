require 'browser/socket'

class PushMessage
  def initialize(&block)
    @listeners = {}

    @socket = Browser::Socket.new("ws://#{`window.location.host`}/websocket")
    @socket.on(:message) do |message|
      (cmd, _, body) = message.data.partition(': ')
      @listeners[cmd].each {|l| l.call(cmd, body) } if @listeners[cmd]
    end
    @socket.on(:open) { block.call(self) } if block
  end

  def self.init(&block)
    @default = PushMessage.new(&block)
  end

  def self.default
    @default
  end

  def on_receive(command, &block)
    (@listeners[command] ||= []) << block
  end

  def write(command, message)
    @socket.write("#{command} #{message}")
  end
end
