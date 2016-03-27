require 'spec_helper'

describe Vargs do
  describe 'single argument' do
    let(:klass) {
      Class.new do
        extend Vargs::DSL
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

  describe 'multiple arguments' do
    let(:klass) {
      Class.new do
        extend Vargs::DSL
        validate_args :sum, [Numeric, Numeric]
        def sum(x, y)
          x + y
        end
      end
    }

    it "no exception" do
      expect(klass.new.sum(1,2)).to eq 3
    end

    it "exception" do
      expect { klass.new.sum(:no_int, 2) }.to raise_error Vargs::ArgumentTypeError
    end
  end

  describe 'hash arguments' do
    let(:klass) {
      Class.new do
        extend Vargs::DSL
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
    }

    it "no exception" do
      expect(
        klass.new.do_something(
          'uri' => 'http://example.com',
          'host' => 'example.com',
          'path_query' => '/path',
        )
      ).to eq Hash[
        'uri' => 'http://example.com',
        'schema' => 'http',
        'host' => 'example.com',
        'path_query' => '/path',
        'method' => 'GET',
      ]
    end

    it "exception" do
      expect { klass.new.do_something('uri' => 1 ) }.to raise_error Vargs::ArgumentTypeError
    end
  end

  describe 'class + hash arguments' do
    let(:klass) {
      Class.new do
        extend Vargs::DSL
        validate_args :do_something, [Symbol, {
          'uri'        => { isa: String },
          'schema'     => { isa: String, default: 'http' },
        }]
        def do_something(sym, params)
          return [sym, params]
        end
      end
    }

    it "no exception" do
      expect(
        klass.new.do_something(
          :hello,
          'uri' => 'http://example.com',
        )
      ).to eq [
        :hello, {
          'uri' => 'http://example.com',
          'schema' => 'http',
        }
      ]
    end

    it "exception" do
      expect { klass.new.do_something(:sym, 'uri' => 1 ) }.to raise_error Vargs::ArgumentTypeError
    end
  end
end
