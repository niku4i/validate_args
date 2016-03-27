require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

#  Benchmark
#-----------------------------------------------
desc "Compare with pure ruby and rubype"
task :benchmark do
  require "benchmark/ips"
  require "vargs"
  require "vargs/version"
  require 'rubype'
  require 'rubype/version'

  puts "ruby version: #{RUBY_VERSION}"
  class PureClass
    def sum(x, y)
      x + y
    end
  end
  pure_instance = PureClass.new

  puts "vargs version: #{Vargs::VERSION}"
  class VargsClass
    extend Vargs::DSL
    validate_args :sum, [Numeric, Numeric]
    def sum(x, y)
      x + y
    end
  end
  vargs_instance = VargsClass.new

  puts "rubype version: #{Rubype::VERSION}"
  class RubypeClass
    def sum(x, y)
      x + y
    end
    typesig :sum, [Numeric, Numeric] => Numeric
  end
  rubype_instance = RubypeClass.new


  Benchmark.ips do |x|
    x.report('Pure Ruby') { pure_instance.sum(4, 2) }
    x.report('Vargs') { vargs_instance.sum(4, 2) }
    x.report('Rubype') { rubype_instance.sum(4, 2) }

    x.compare!
  end
end
task bm: :benchmark

#  Benchmark2 hash validation
#-----------------------------------------------
desc "Compare with pure ruby and rubype for hash validation"
task :benchmark2 do
  require "benchmark/ips"
  require "vargs"
  require "vargs/version"
  require 'rubype'
  require 'rubype/version'

  puts "ruby version: #{RUBY_VERSION}"
  class PureClass
    def do_something(params = {})
      params
    end
  end
  pure_instance = PureClass.new

  puts "vargs version: #{Vargs::VERSION}"
  class VargsClass
    extend Vargs::DSL
    validate_args :do_something, 'uri' => String
    def do_something(params = {})
      params
    end
  end
  vargs_instance = VargsClass.new

  puts "rubype version: #{Rubype::VERSION}"
  class RubypeClass
    def do_something(params = {})
      params
    end
    typesig :do_something, [Hash] => Hash
  end
  rubype_instance = RubypeClass.new

  Benchmark.ips do |x|
    x.report('Pure Ruby') { pure_instance.do_something('uri' => 'example.com') }
    x.report('Vargs') { vargs_instance.do_something('uri' => 'example.com') }
    x.report('Rubype') { rubype_instance.do_something('uri' => 'example.com') }

    x.compare!
  end
end
task bm2: :benchmark2

#  Benchmark3 pure data-validator vs vargs
#-----------------------------------------------
desc "Compare with pure data-validator and vargs"
task :benchmark3 do
  require "benchmark/ips"
  require "vargs"
  require "vargs/version"
  require 'data/validator'
  require 'data/validator/version'

  puts "data validator version: #{Data::Validator::VERSION}"
  class DataValidatorClass
    @@validator = Data::Validator.new('uri' => String)
    def do_something(params = {})
      @@validator.validate params
    end
  end
  data_validator_instance = DataValidatorClass.new

  puts "vargs version: #{Vargs::VERSION}"
  class VargsClass
    extend Vargs::DSL
    validate_args :do_something, 'uri' => String
    def do_something(params = {})
      params
    end
  end
  vargs_instance = VargsClass.new

  Benchmark.ips do |x|
    x.report('DataValidator') { data_validator_instance.do_something('uri' => 'example.com') }
    x.report('Vargs') { vargs_instance.do_something('uri' => 'example.com') }

    x.compare!
  end
end
task bm3: :benchmark3

desc "Memory growth test"
task :mem_benchmark do
  require "vargs"
  require "vargs/version"
  N = (ENV['N'] || 100_000).to_i

  puts "vargs version: #{Vargs::VERSION}"
  class Foo
    extend Vargs::DSL
    validate_args :do_something, [Numeric, 'uri' => String]
    def do_something(i, params)
    end
  end
  N.times do |i|
    Foo.new.do_something(1, 'uri' => 'example.com')
    if (i%10_000) == 0
      GC.start
      p `ps -o rss= -p #{Process.pid}`.to_i
    end
  end
end
