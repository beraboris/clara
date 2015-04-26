Given(/have a file named "(.*?)" containing$/) do |name, body|
  name = File.expand_path name
  FileUtils.mkpath File.dirname(name)
  File.write name, body
end

Then(/should find "(.*?)" containing$/) do |name, body|
  name = File.expand_path name
  expect(File.exist?(name)).to be_truthy
  expect(File.read(name)).to eq body
end
