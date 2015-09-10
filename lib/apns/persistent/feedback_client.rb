require 'forwardable'
require 'json'

module Apns
  module Persistent
    class FeedbackClient
      def initialize(certificate: , passphrase: nil, sandbox: true)
        cer = File.read(certificate)
        @connection = Connection.new(FeedbackClient.gateway_uri(sandbox), cer, passphrase)
      end

      def unregistered_devices
        devices = []

        @connection.open
        while line = @connection.read(38)
          feedback = line.unpack('N1n1H140')
          timestamp = feedback[0]
          token = feedback[2].scan(/.{0,8}/).join(' ').strip
          devices << {token: token, timestamp: timestamp} if token && timestamp
        end
        @connection.close

        devices
      end

      def unregistered_devices_token
        unregistered_devices.collect{|device| device[:token]}
      end

      private

      def self.gateway_uri(sandbox)
        sandbox ? "apn://feedback.sandbox.push.apple.com:2196" : "apn://feedback.push.apple.com:2196"
      end
    end
  end
end
