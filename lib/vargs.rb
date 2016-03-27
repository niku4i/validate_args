module Vargs
  require "vargs/version"
  require "vargs/error_printer"
  require "vargs/dsl"
  require "vargs/validators"

  class ArgumentTypeError < StandardError; end

  class << self
    def validate!(owner, meth, args)
      rules = Validators.get_validator(owner, meth)
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
