# ActionTracer

Log Rails application actions and filters when accepts a request.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'action_tracer', group :development, :test
```

Notice this gem is for Rails with ApplicationController inherited ActiveController::Base.  
Support for Rails application with ActiveController::API is comming soon.

## Usage

Run rails server or run rspec with `ACTION_TRACER=1` to log actions and filters for `log/action_tracer.log`.

```bash
$ ACTION_TRACER=1 rails server
```

You can also run rspec for your request specs.

```bash
$ ACTION_TRACER=1 rspec
```

If you use docker-compose, pass environment variable:

```yml
version: 3
services:
  web:
    build: .
    command: bundle exec rails s -p 3000
    environment:
      ACTION_TRACER: 1
    volumes:
      # ...
```

### Example

For example, you have a simple `awesome_controller.rb` like this:

```ruby
class AwesomeController < ApplicationController
  before_action :require_login
  before_action :set_awesome, only: :show
  around_action :with_readonly
  after_action :store_location
  
  def index
   # ...
  end

  def show
    # ...
  end

private

  def require_login
    # ...
  end

  def with_readonly
    # ...
    yield
    # ...
  end

  def store_location
    # ...
  end
end
```

When you run rails server with `ACTION_TRACER=1` and access `/awesome` (action is `#index`),    
it will put logs for `log/action_tracer.log` like this:

```log
I, [2020-09-27T03:25:43.018298 #1]  INFO -- : ["APPLIED", :set_turbolinks_location_header_from_session, "/usr/local/bundle/gems/turbolinks-5.2.1/lib/turbolinks/redirection.rb", 43]
I, [2020-09-27T03:25:43.019410 #1]  INFO -- : ["APPLIED", :verify_authenticity_token, "/usr/local/bundle/gems/actionpack-5.1.7/lib/action_controller/metal/request_forgery_protection.rb", 211]
I, [2020-09-27T03:25:43.021131 #1]  INFO -- : ["APPLIED", :require_login, "/myapp/app/controllers/awesome_controller.rb", 17]
I, [2020-09-27T03:25:43.022063 #1]  INFO -- : ["NO_APPLIED", :set_awesome, "/myapp/app/controllers/awesome_controller.rb", 25]
I, [2020-09-27T03:25:43.023716 #1]  INFO -- : ["APPLIED", :with_readonly, "/myapp/app/controllers/awesome_controller.rb", 21]
I, [2020-09-27T03:25:43.025547 #1]  INFO -- : ["ACTION", :index, "/myapp/app/controllers/awesome_controller.rb", 7]
I, [2020-09-27T03:25:43.026297 #1]  INFO -- : ["APPLIED", :with_readonly, "/myapp/app/controllers/awesome_controller.rb", 21]
I, [2020-09-27T03:25:43.027203 #1]  INFO -- : ["APPLIED", :store_location, "/myapp/app/controllers/awesome_controller.rb", 27]
I, [2020-09-27T03:25:43.030074 #1]  INFO -- : ["APPLIED", :verify_same_origin_request, "/usr/local/bundle/gems/actionpack-5.1.7/lib/action_controller/metal/request_forgery_protection.rb", 240]
I, [2020-09-27T03:25:43.030776 #1]  INFO -- : 
```

Filters are put in the order in which is executed.  
Notice `around_action` is put 2 times around action though called 1 time.

### Log Guide

Normally log is put in this format:

```ruby
["APPLIED", :require_login, "/myapp/app/controllers/awesome_controller.rb", 17]
```

1. State. One of `APPLIED`, `NO_APPLIED` and `ACTION`.  
`APPLIED`: Filter is executed.  
`NO_APPLIED`: Filter is registered but not executed.  
`ACTION`: Called action.
2. Method name. When filter is a Proc, just put `:Proc`.
3. File path. It's absolute path.
4. Method line no.

When filter is an object, log is put in this format:

```ruby
["UNRECOGNIZED", #<Awesome::Object:0x00007f95c35768f8>]
```

We can't recgnize the filter is actually executed or not.

## CommingFeatures

- Support for Rails application with ActiveController::API
- Add non-checking mode
  - Memorizing filters are applied or not is very costly.  
  Add non-checking mode filters are actually applied or not.
- Log rotate

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/makicamel/action_tracer. This project is intended to be a safe, welcoming space for collaboration.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActionTracer project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/makicamel/action_tracer/blob/master/CODE_OF_CONDUCT.md).
