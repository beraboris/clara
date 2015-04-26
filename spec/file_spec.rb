require 'spec_helper'

describe Clara::File do
  describe '::read' do
    include FakeFS::SpecHelpers

    it 'should load file from its path' do
      File.write '/stuff.txt', 'many things'
      file = Clara::File.read '/stuff.txt'

      expect(file.template.result).to eq 'many things'
    end
  end

  describe '#options' do
    it 'should return the file options when provided' do
      file = Clara::File.new <<-FILE.gsub(/^\s+/, '')
        ---
        foo: bar
        ---
      FILE

      expect(file.options['foo']).to eq 'bar'
    end

    it 'should return empty options when none available' do
      file = Clara::File.new 'stuff'

      expect(file.options).to eq({})
    end
  end

  describe '#template' do
    it 'should build a template' do
      file = Clara::File.new '<%= 21 * 2 %>'

      expect(file.template.result).to eq '42'
    end
  end
end
