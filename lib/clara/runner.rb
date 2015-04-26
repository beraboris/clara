require 'boson/runner'
require 'clara/file'

module Clara
  # The command line runner.
  #
  # This uses Boson, for more details see the boson documentation.
  class Runner < Boson::Runner
    option :system, type: :boolean, desc: 'system wide install', default: false
    option :user, type: :boolean, desc: 'user install', default: true
    def install(package, options = {})
      file = Clara::File.read package

      location = file.options[location_option(options)]
      FileUtils.mkpath ::File.dirname(location)

      ::File.write location, file.template.result
    end

    private

    def location_option(options)
      if user_install? options
        'user_location'
      else
        'system_location'
      end
    end

    def user_install?(options)
      options[:user] && !options[:system]
    end
  end
end
