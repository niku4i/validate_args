module ValidateArgs
  require "validate_args/version"
  require "validate_args/error_printer"
  require "validate_args/validators"

  class ArgumentTypeError < StandardError; end

  private

  def __proxy__
    @__proxy__ ||= Module.new.tap {|proxy| prepend proxy }
  end

  # Define DSL
  def validate_args(meth, rules)
    Validators.register_validator(self, meth, rules, __proxy__)
    self
  end
end
