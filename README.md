# Rack::ForceStatus

Rack::ForceStatus is a simple Rack middleware for forcing status codes on responses. This is useful for dealing with things like [XDomainRequest's inability to provide responseText on errors](http://stackoverflow.com/questions/10390539/xdomainrequest-get-response-body-on-error). We can now return the error with a 200 response that XDomainRequest can receive and handle.

## Installation

Install the Rack::ForceStatus gem with a simple:

```ruby
gem install rack-force-status
```

Or add it to your Gemfile:

```ruby
gem 'rack-force-status'
```

## Usage

Use the Rack::ForceStatus middleware like anything else:

```ruby
use Rack::ForceStatus
```

Or for Rails application, add the following line to your application config file (config/application.rb for Rails 3 & 4, config/environment.rb for Rails 2):

```ruby
config.middleware.use Rack::ForceStatus
```

From there you can force the status on any request by passing a ```force_status``` param, set to the value of the status you'd like. For example, if you'd like everything to always return successful, you'd do:

```
http://myapp.com/some/path?force_status=200
```

In addition to forcing the status to whatever you've specified, if the original status was different you will get a header added telling you what it was originally.

```
X-Original-Status-Code: 422
```

## Options

If you'd like to customize the incoming param name or the outgoing header name, you can pass them as options.

```ruby
config.middleware.use Rack::ForceStatus, :param => 'my-custom-param', :header => 'My-Custom-Header'
```
