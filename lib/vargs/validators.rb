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
            ::Vargs.validate!(self, meth, args)
            super(*args)
          end
        end
      end
      
      def get_validator(owner, meth)
        @@validators[owner][meth]
      end
    end
  end
end
