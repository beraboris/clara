require 'rspec'
require 'clara/package_storage'

describe 'PackageStorage' do
  before :all do
    @handlers = [:h1, :h2, :h3, :h4].map do |name|
      Class.new(Clara::PackageStorage::Base) do
        const_set :NAME, name
        def self.handles?(path)
          path == self::NAME.to_s
        end

        def initialize(_)
        end
      end
    end
  end

  it 'registers handlers on inheritance' do
    c = Class.new(Clara::PackageStorage::Base) { def self.handles?(_); false; end }
    Clara::PackageStorage.class_variable_get(:@@handlers).include?(c).should be_true
  end

  it 'creates handlers' do
    handler = Clara::PackageStorage.create('h1')
    handler.class::NAME.should == :h1
  end

  it 'throws an error when there are no handlers' do
    proc {Clara::PackageStorage.create("Can't touch this!")}.should raise_error(Clara::UnsupportedPackageTypeError)
  end
end
