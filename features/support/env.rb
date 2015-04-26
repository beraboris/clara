require 'coveralls'
Coveralls.wear!

require 'rspec'
require 'fakefs/safe'
require 'clara'

Before do
  FakeFS.activate!
end

After do
  FakeFS.deactivate!
end
