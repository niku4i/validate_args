require 'data/validator'
require 'vargs'

module Vargs
  module Validators
    @@validators = Hash.new({})

    class << self

      def register_validator(owner, meth, rules, __proxy__)
        rules = [rules] unless rules.is_a? Array
        @@validators[owner][meth] = rules.map {|rule| Data::Validator.new(rule) }
        __proxy__.module_eval do
          define_method(meth) do |*args|
            ::Vargs::Validators.validate!(self, meth, args)
            super(*args)
          end
        end
      end
      
      def get_validator(owner, meth)
        @@validators[owner][meth]
      end

      def validate!(owner, meth, args)
        rules = get_validator(owner, meth)
        errors = []
        rules.zip(args).each_with_index do |(rule, arg), i|
          if rule and arg
            begin
              rule.validate(arg)
            rescue ::Data::Validator::Error => e
              errors[i] = e.message
            end
          end
        end
        raise ArgumentTypeError, ErrorPrinter.new(owner, meth, errors).to_s if !errors.empty?
        true
      end
    end
  end
end
