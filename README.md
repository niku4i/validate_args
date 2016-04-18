# ValidateArgs [![Build Status](https://travis-ci.org/niku4i/validate_args.svg?branch=master)](https://travis-ci.org/niku4i/validate_args)

ValidateArgs allows you to specify validations for method arguments, using `validate_args` to supply validation rules of a hash or array. Validations you declared would be called automatically before method calls.

The syntax of validation rules is the same as shyouhei's [data-validator](https://github.com/shyouhei/data-validator) because ValidateArgs dispatches rules and validations to data-validator internally.

## Example

### Basic usages

```ruby
require 'validate_args'

class MyClass

  extend ValidateArgs

  validate_args :do_something, 'foo' => Numeric
  def do_something(params)
    return params
  end

end

# pass validation
MyClass.new.do_something('foo' => 42) 
# => {"foo"=>42}

# pass
MyClass.new.do_something('foo' => 0, 'baz' => 42, 'qux' => 100) 
# => {"foo"=>0, "baz"=>42, "qux"=>100}

# validation failure
MyClass.new.do_something('foo' => 'string') 
# => ValidateArgs::ArgumentTypeError: for MyClass#do_something's 1st argument is invalid => foo:type mismatch

# validation failure
MyClass.new.do_something('bar' => 1) 
# => ValidateArgs::ArgumentTypeError: for MyClass#do_something's 1st argument is invalid => ["foo"] missing
```

### Complex cases

```ruby
require 'validate_args'

class MyClass

  extend ValidateArgs

  validate_args :do_something, {
    'foo' => { isa: Numeric, default: 99 },
    'bar' => { isa: Numeric, default: lambda {|validator, rule, args| args['foo'] + 1 } },
    'baz' => { isa: String, optional: true }
  }
  def do_something(params)
    return params
  end
end

# pass
MyClass.new.do_something('foo' => 1, 'bar' => 2)
# => {"foo"=>1, "bar"=>2}


# pass (`bar` is calculated)
MyClass.new.do_something('foo' => 5)
# => {"foo"=>5, "bar"=>6}
```

### non hash arguments

```ruby
require 'validate_args'

class MyClass

  extend ValidateArgs

  validate_args :sum, [Numeric, Numeric]
  def sum(x, y)
    x + y
  end

end

# pass 
MyClass.new.sum(1, 2)   
# => 3

# validation failure
MyClass.new.sum(1, 'a')
# => ValidateArgs::ArgumentTypeError: for MyClass#sum's 2nd argument is invalid => type mismatch
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'validate_args'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install validate_args

## Similar gems

* [data-validator](https://github.com/shyouhei/data-validator)
  * ValidateArgs just wraps it to provide `validate_args` class method as DSL.
* [Rubype](https://github.com/gogotanaka/Rubype)
  * Rubype is super cool gem!
  * Rubype does not validate values of given hashes because it focuses on checking classes of given args.
  * Rubype is faster than ValidateArgs
  * Rubype can check return value, but ValidateArgs does not for now. (patches are welcome though!)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/validate_args.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

