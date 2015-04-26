When(/install "(.*?)" system wide$/) do |file|
  Clara::Runner.start ['install', file, '--system']
end

When(/install "(.*?)" for my user$/) do |file|
  Clara::Runner.start ['install', file, '--user']
end

When(/install "(.*?)"$/) do |file|
  Clara::Runner.start ['install', file]
end
