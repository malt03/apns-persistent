require 'uri'
require 'socket'
require 'openssl'
require 'forwardable'

module Apns
  module Persistent
    class Connection
      extend Forwardable
      def_delegators :@ssl, :read, :write

      def initialize(uri, certificate, passphrase)
        @uri = URI(uri)
        @certificate = certificate
        @passphrase = passphrase
      end

      def open
        @socket = TCPSocket.new(@uri.host, @uri.port)
        context = OpenSSL::SSL::SSLContext.new
        context.key = OpenSSL::PKey::RSA.new(@certificate, @passphrase)
        context.cert = OpenSSL::X509::Certificate.new(@certificate)
        @ssl = OpenSSL::SSL::SSLSocket.new(@socket, context)
        @ssl.sync
        @ssl.connect
      end

      def close
        @ssl.close
        @socket.close
        @ssl = nil
        @socket = nil
      end

      def reopen
        close
        open
      end

      def opened?
        !(@ssl.nil? || @socket.nil?)
      end

      def closed?
        !opened?
      end

      def readable?
        r, w = IO.select([@ssl], [], [@ssl], 1)
        (r && r[0])
      end
    end
  end
end
