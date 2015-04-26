require 'clara'
require 'support/run'
require 'support/packages'

describe 'Single file install' do
  include FakeFS::SpecHelpers

  let(:packages) { Pathname.new '/packages' }

  it 'should install as root' do
    source = packages + 'something.conf'
    destination = Pathname.new '/etc/something.conf'

    make_file_package source, 'Stuff',
                      system_location: '/etc/something.conf'

    run_clara 'install', source.to_s, '--system'

    expect(destination).to exist
  end

  it 'should install as user' do
    source = packages + 'something.conf'
    destination = Pathname.new('~/.something.conf').expand_path

    make_file_package source, 'Stuff',
                      user_location: '~/.something.conf'

    run_clara 'install', source.to_s, '--user'

    expect(destination).to exist
  end

  it 'should default to installing as root' do
    source = packages + 'something.conf'
    destination = Pathname.new('~/.something.conf').expand_path

    make_file_package source, 'Stuff',
                      user_location: '~/.something.conf'

    run_clara 'install', source.to_s

    expect(destination).to exist
  end

  it 'should template the file' do
    source = packages + 'something.conf'
    destination = Pathname.new('~/.something.conf').expand_path

    make_file_package source, 'The answer is <%= 42 %>.',
                      user_location: '~/.something.conf'

    run_clara 'install', source.to_s

    expect(destination).to exist
    expect(File.read(destination).chomp).to eq 'The answer is 42.'
  end

  it 'should expand ~' do
    source = packages + 'hello.conf'
    home = Pathname.new('~').expand_path

    make_file_package source, 'stuff',
                      user_location: '~/hello.conf'

    run_clara 'install', source.to_s, '--user'

    expect(home + 'hello.conf').to exist
  end
end
