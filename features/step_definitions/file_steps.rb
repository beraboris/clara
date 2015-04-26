Given(/have a file named "(.*?)" containing$/) do |name, body|
  FileUtils.mkpath File.dirname(name)
  File.write name, body
end

Then(/should find "(.*?)" containing$/) do |name, body|
  expect(File.exist?(name)).to be_truthy
  expect(File.read(name)).to eq body
end
