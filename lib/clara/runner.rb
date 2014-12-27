require 'boson/runner'
require 'clara/file'

module Clara
  class Runner < Boson::Runner
    option :system, type: :boolean, desc: 'system wide install', default: false
    option :user, type: :boolean, desc: 'user install', default: true
    def install(package, options = {})
      file = Clara::File.read package

      location = user_install?(options) ? file.options['user_location'] : file.options['system_location']
      FileUtils.mkpath ::File.dirname(location)

      ::File.write location, file.template.result
    end

    private

    def user_install?(options)
      options[:user] && !options[:system]
    end
  end
end