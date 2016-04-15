# validate_args

validates method arguments with data-validator syntax.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'validate_args'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install validate_args

## Usage

Define validation rule with `validate_args` syntax and rule.

```ruby

require 'validate_args'

class MyClass

  extend ValidateArgs

  validate_args :sum, [Numeric, Numeric]
  def sum(x, y)
    x + y
  end
end

MyClass.new.sum(1, 2)
#=> 3

MyClass.new.sum(1, 'string')
# exception


class MyClass

  validate_args :do_something, {
    'uri'        => { isa: String },
    'schema'     => { isa: String, default: 'http' },
    'host'       => { isa: String },
    'path_query' => { isa: String, default: '/' },
    'method'     => { isa: String, default: 'GET' },
  }

  def do_something(params)
    return params
  end
end

MyClass.new.do_something(
  'uri' => 'http://example.com',
  'host' => 'example.com',
  'path_query' => '/path',
)
# => {
#      'uri' => 'http://example.com',
#      'schema' => 'http',
#      'host' => 'example.com',
#      'path_query' => '/path',
#      'method' => 'GET',
#    }

MyClass.new.do_something(
  'uri' => 1,
)
# => exception

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/validate_args.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

