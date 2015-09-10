require 'forwardable'
require 'json'

module Apns
  module Persistent
    class Client
      extend Forwardable
      def_delegators :@connection, :open, :close, :opened?, :closed?

      def initialize(certificate: , passphrase: nil, sandbox: true)
        cer = File.read(certificate)
        @connection = Connection.new(self.class.gateway_uri(sandbox), cer, passphrase)
      end

      private

      def self.gateway_uri(sandbox)
        raise 'please inherit'
      end
    end
  end
end
