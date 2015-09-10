# Apns::Persistent

apns-persisitent is referencing [houston](https://rubygems.org/gems/houston/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'apns-persistent'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install apns-persistent

## Push Usage
[Examples](https://github.com/malt03/apns-persistent/tree/master/exe)

### Recommend
```ruby
c = Apns::Persistent::PushClient.new(certificate: '/path/to/apple_push_notification.pem', sandbox: true)
c.open

thread = c.regist_error_handle do |command, status, id|
  #error handle
  puts "Send Error! command:#{command} status:#{status} id:#{id}"
end

c.push(token: '88189fcf 62a1b2eb b7cb1435 597e734e a90da4ce 6196a9b3 309a5421 4c6259e',
       alert: 'foobar',
       sound: 'default',
       id: 1)

begin
  thread.join
rescue Interrupt
  c.close
end
```

### Without Thread
```ruby
c = Apns::Persistent::PushClient.new(certificate: '/path/to/apple_push_notification.pem', sandbox: true)
c.open
c.push(token: '88189fcf 62a1b2eb b7cb1435 597e734e a90da4ce 6196a9b3 309a5421 4c6259e',
       alert: 'foobar',
       sound: 'default',
       id: 1) do |command, status, id|
  #error handle
  puts "Send Error! command:#{command} status:#{status} id:#{id}"
end
c.close
```

### Without Persistent Connections
```ruby
Apns::Persistent::PushClient.push_once(certificate: '/path/to/apple_push_notification.pem',
                                       token: '88189fcf 62a1b2eb b7cb1435 597e734e a90da4ce 6196a9b3 309a5421 4c6259e9',
                                       alert: 'foobar',
                                       sound: 'default',
                                       id: 1) do |command, status, id|
  #error handle
  puts "Send Error! command:#{command} status:#{status} id:#{id}"
end
```

## Feedback API Usage
### Get unregistered devices
```ruby
c = Apns::Persistent::FeedbackClient.new(certificate: '/path/to/apple_push_notification.pem', sandbox: true)
c.open
devices = c.unregistered_devices
c.close
```

### Get unregistered device tokens
```ruby
c = Apns::Persistent::FeedbackClient.new(certificate: '/path/to/apple_push_notification.pem', sandbox: true)
c.open
device_tokens = c.unregistered_device_tokens
c.close
```

### Get unregistered devices once
```ruby
devices = Apns::Persistent::FeedbackClient.unregistered_devices_once(certificate: '/path/to/apple_push_notification.pem', sandbox: true)
```

### Get unregistered device tokens once
```ruby
device_tokens = Apns::Persistent::FeedbackClient.unregistered_device_tokens_once(certificate: '/path/to/apple_push_notification.pem', sandbox: true)
```

## Command Line Tools
### Launch Daemon
```console
$ push_daemon --pemfile <path> [--sandbox]
```
### Push after launch daemon
```console
$ push --token <token> --alert "Hello" --badge 2 --sound "default"
```

### Push once
```console
$ push_once --pemfile <path> [--sandbox] --token <token> --alert "Hello" --sound "default" --badge 2
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/malt03/apns-persistent. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

