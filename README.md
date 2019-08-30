
[![Build Status](https://travis-ci.com/foodiefm/restclient-opentracing.svg?branch=master)](https://travis-ci.com/foodiefm/restclient-opentracing)
[![Coverage Status](https://coveralls.io/repos/github/foodiefm/restclient-opentracing/badge.svg?branch=master)](https://coveralls.io/github/foodiefm/restclient-opentracing?branch=master)
[![Gem Version](https://badge.fury.io/rb/restclient-opentracing.svg)](https://badge.fury.io/rb/restclient-opentracing)
# RestClient::Opentracing


Opentracing instrumentation for RestClient


TODO: publish the gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'restclient-opentracing'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install restclient-opentracing

## Usage


```
require 'restclient/opentracing'

RestClient::OpenTracing.instrument
```

disable passing traces down the wire:

```
require 'restclient/opentracing'

RestClient::OpenTracing.instrument do |config|
  config.distributed_tracing = false
end
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/foodiefm/restclient-opentracing. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RestClient::Opentracing project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/foodiefm/restclient-opentracing/blob/master/CODE_OF_CONDUCT.md).
