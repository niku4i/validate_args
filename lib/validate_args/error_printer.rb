require 'validate_args/utils'

module ValidateArgs
  class ErrorPrinter
    def initialize(owner, meth, errors)
      @owner = owner
      @meth = meth
      @errors = errors
    end

    def to_s
      @errors.zip(0..@errors.size).reject{|message, i| message.nil? }.map do |message, i|
        "for #{@owner.class}##{@meth}'s #{Utils.ordinalize(i+1)} argument is invalid => #{message}"
      end.join("\n")
    end

  end
end
