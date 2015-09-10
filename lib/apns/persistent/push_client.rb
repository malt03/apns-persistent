require 'json'

module Apns
  module Persistent
    class PushClient < Client
      def self.push_once(certificate: ,
                         passphrase: nil,
                         sandbox: true,

                         token: ,
                         alert: nil,
                         badge: nil,
                         sound: nil,
                         category: nil,
                         content_available: true,
                         custom_payload: nil,
                         id: nil,
                         expiry: nil,
                         priority: nil)

        client = Client.new(certificate: certificate, passphrase: passphrase, sandbox: sandbox)
        client.open

        client.push(token: token,
                    alert: alert,
                    badge: badge,
                    sound: sound,
                    category: category,
                    content_available: content_available,
                    custom_payload: custom_payload,
                    id: id,
                    expiry: expiry,
                    priority: priority) do |command, status, return_id|
          if block_given?
            yield(command, status, return_id)
          end
        end

        client.close
      end

      def push(token: ,
               alert: nil,
               badge: nil,
               sound: nil,
               category: nil,
               content_available: true,
               custom_payload: nil,
               id: nil,
               expiry: nil,
               priority: nil)
        
        raise 'please open' if closed?

        m = Client.message(token, alert, badge, sound, category, content_available, custom_payload, id, expiry, priority)
        @connection.write(m)

        if block_given? && @connection.readable?
          if error = @connection.read(6)
            command, status, return_id = error.unpack('ccN')
            yield(command, status, return_id)
            @connection.reopen
          end
        end
      end

      def regist_error_handle
        Thread.new do
          while error = @connection.read(6)
            command, status, id = error.unpack('ccN')
            yield(command, status, id)
            @connection.reopen
          end
        end
      end

      class << self
        private

        def gateway_uri(sandbox)
          sandbox ? "apn://gateway.sandbox.push.apple.com:2195" : "apn://gateway.push.apple.com:2195"
        end

        def message(token, alert, badge, sound, category, content_available, custom_payload, id, expiry, priority)
          data = [token_data(token),
                  payload_data(custom_payload, alert, badge, sound, category, content_available),
                  id_data(id),
                  expiration_data(expiry),
                  priority_data(priority)].compact.join
          [2, data.bytes.count, data].pack('cNa*')
        end

        def token_data(token)
          [1, 32, token.gsub(/[<\s>]/, '')].pack('cnH64')
        end

        def payload_data(custom_payload, alert, badge, sound, category, content_available)
          payload = {}.merge(custom_payload || {}).inject({}){|h,(k,v)| h[k.to_s] = v; h}

          payload['aps'] ||= {}
          payload['aps']['alert'] = alert if alert
          payload['aps']['badge'] = badge.to_i rescue 0 if badge
          payload['aps']['sound'] = sound if sound
          payload['aps']['category'] = category if category
          payload['aps']['content-available'] = 1 if content_available
          
          json = payload.to_json
          [2, json.bytes.count, json].pack('cna*')
        end

        def id_data(id)
          [3, 4, id].pack('cnN') unless id.nil?
        end

        def expiration_data(expiry)
          [4, 4, expiry.to_i].pack('cnN') unless expiry.nil?
        end

        def priority_data(priority)
          [5, 1, priority].pack('cnc') unless priority.nil?
        end
      end
    end
  end
end
