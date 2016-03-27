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
