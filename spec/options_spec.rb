require 'clara/options'

describe Clara::Options do
  describe '#[]' do
    it 'should get the raw option values' do
      options = Clara::Options.new('foo' => 'bar')
      expect(options['foo']).to eq 'bar'
    end
  end

  describe '#destination' do
    it 'should return the system destination' do
      options = Clara::Options.new 'system_location' => '/foo/bar/thing.conf'
      expect(options.destination false).to eq '/foo/bar/thing.conf'
    end

    it 'should return the user destination' do
      options = Clara::Options.new 'user_location' => '/biz/baz/stuff.conf'
      expect(options.destination true).to eq '/biz/baz/stuff.conf'
    end
  end

  describe '#empty?' do
    it 'should return true if the hash is empty' do
      options = Clara::Options.new({})
      expect(options.empty?).to eq true
    end

    it 'should return false when we have options' do
      options = Clara::Options.new 'foo' => 'bar'
      expect(options.empty?).to eq false
    end
  end
end
