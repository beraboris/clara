require 'rspec'
require 'clara/utils/abstract'

describe 'Abstract Util' do
  before :each do
    @abstract_class = Class.new do
      extend Clara::Utils::Abstract

      abstract_methods :foo, :bar
      abstract_class_methods :class_foo, :class_bar
    end
  end

  it 'creates instance methods' do
    k = @abstract_class.new

    k.respond_to?(:foo).should be_true
    k.respond_to?(:bar).should be_true
  end

  it 'creates class methods' do
    @abstract_class.respond_to?(:class_foo).should be_true
    @abstract_class.respond_to?(:class_bar).should be_true
  end

  it 'raises errors on instance methods' do
    proc {@abstract_class.new.foo}.should raise_error(NotImplementedError)
    proc {@abstract_class.new.bar}.should raise_error(NotImplementedError)
  end

  it 'raises errors on class methods' do
    proc {@abstract_class.class_foo}.should raise_error(NotImplementedError)
    proc {@abstract_class.class_bar}.should raise_error(NotImplementedError)
  end

  it 'can be overwritten (instance methods)' do
    subclass = Class.new(@abstract_class) do
      def foo
        :overwritten
      end
    end

    subclass.new.foo.should == :overwritten
  end

  it 'can be overwritten (class methods)' do
    subclass = Class.new(@abstract_class) do
      def self.foo
        :overwritten
      end
    end

    subclass.foo.should == :overwritten
  end
end
