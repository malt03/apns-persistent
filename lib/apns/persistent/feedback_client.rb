module Apns
  module Persistent
    class FeedbackClient < Client
      def unregistered_devices
        raise 'please open' if closed?

        devices = []
        while line = @connection.read(38)
          feedback = line.unpack('N1n1H140')
          timestamp = feedback[0]
          token = feedback[2].scan(/.{0,8}/).join(' ').strip
          devices << {token: token, timestamp: timestamp} if token && timestamp
        end
        devices
      end

      def unregistered_device_tokens
        unregistered_devices.collect{ |device| device[:token] }
      end

      def self.gateway_uri(sandbox)
        sandbox ? "apn://feedback.sandbox.push.apple.com:2196" : "apn://feedback.push.apple.com:2196"
      end
    end
  end
end
