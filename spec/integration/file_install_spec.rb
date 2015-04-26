require 'clara'
require 'clara/file_package'
require 'support/run'
require 'support/packages'

describe 'Single file install' do
  let(:packages) { Pathname.new '/packages' }
  let(:package) { double 'package' }

  before do
    allow(Clara::FilePackage).to receive(:new).and_return package
  end

  it 'should load the package file' do
    source = packages + 'butts.cfg'
    expect(Clara::FilePackage).to receive(:new).with source
    allow(package).to receive(:install!).with(anything)

    run_clara 'install', source.to_s
  end

  it 'should install for system' do
    source = packages + 'something.conf'

    expect(package).to receive(:install!).with(false)

    run_clara 'install', source.to_s, '--system'
  end

  it 'should install for user' do
    source = packages + 'something.conf'

    expect(package).to receive(:install!).with(true)

    run_clara 'install', source.to_s, '--user'
  end

  it 'should default to installing for user' do
    source = packages + 'something.conf'

    expect(package).to receive(:install!).with(true)

    run_clara 'install', source.to_s
  end
end
