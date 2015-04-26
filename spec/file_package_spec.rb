require 'spec_helper'
require 'clara/file_package'
require 'support/packages'

describe Clara::FilePackage do
  include FakeFS::SpecHelpers

  describe '#initialize' do
    it 'should blow up if the file is missing' do
      path = Pathname.new '/not-there.ini'
      expect { Clara::FilePackage.new path }.to raise_error(Clara::PackageError)
    end
  end

  describe '#install!' do
    let(:packages) { Pathname.new '/packages' }

    it 'should install for system' do
      source = packages + 'something.conf'
      destination = Pathname.new '/etc/something.conf'

      make_file_package source, 'Stuff',
                        system_location: '/etc/something.conf'

      Clara::FilePackage.new(source).install!(false)

      expect(destination).to exist
    end

    it 'should install for user' do
      source = packages + 'something.conf'
      destination = Pathname.new('~/.something.conf').expand_path

      make_file_package source, 'Stuff',
                        user_location: '~/.something.conf'

      Clara::FilePackage.new(source).install!(true)

      expect(destination).to exist
    end

    it 'should template the file' do
      source = packages + 'something.conf'
      destination = Pathname.new('~/.something.conf').expand_path

      make_file_package source, 'The answer is <%= 42 %>.',
                        user_location: '~/.something.conf'

      Clara::FilePackage.new(source).install!(true)

      expect(destination).to exist
      expect(File.read(destination).chomp).to eq 'The answer is 42.'
    end

    it 'should expand ~' do
      source = packages + 'hello.conf'
      home = Pathname.new('~').expand_path

      make_file_package source, 'stuff',
                        user_location: '~/hello.conf'

      Clara::FilePackage.new(source).install!(true)

      expect(home + 'hello.conf').to exist
    end
  end
end
