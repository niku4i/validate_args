describe Vargs do
  describe 'inherit' do
    let(:klass_base) {
      Class.new do
        extend Vargs::DSL
      end
    }
    let(:klass) {
      Class.new(klass_base) do
        validate_args :hi, String
        def hi(str)
          str
        end
      end
    }
    it "no exception" do
      expect(klass.new.hi('ok')).to eq 'ok'
    end

    it "exception" do
      expect { klass.new.hi(1) }.to raise_error Vargs::ArgumentTypeError
    end
  end

  describe 'orver ride rule on child class' do
    let(:klass_base) {
      Class.new do
        extend Vargs::DSL

        validate_args :hi, Numeric
        def hi(i)
          i
        end
      end
    }
    let(:klass) {
      Class.new(klass_base) do
        validate_args :hi, String
        def hi(str)
          str
        end
      end
    }
    it "no exception" do
      expect(klass.new.hi('ok')).to eq 'ok'
    end

    it "exception" do
      expect { klass.new.hi(1) }.to raise_error Vargs::ArgumentTypeError
    end

  end
end
