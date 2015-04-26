require 'boson/runner'
require 'clara/file_package'
require 'pathname'

module Clara
  # The command line runner.
  #
  # This uses Boson, for more details see the boson documentation.
  class Runner < Boson::Runner
    option :system, type: :boolean, desc: 'system wide install', default: false
    option :user, type: :boolean, desc: 'user install', default: true
    def install(package, options = {})
      FilePackage.new(Pathname.new package).install!(user_install? options)

    rescue PackageError => e
      $stderr.puts "Failed to install #{package}"
      $stderr.puts e.message
    end

    private

    def user_install?(options)
      options[:user] && !options[:system]
    end
  end
end
