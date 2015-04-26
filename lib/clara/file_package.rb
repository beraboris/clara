require 'clara/file'
require 'pathname'

module Clara
  class PackageError < RuntimeError; end

  # A single file contained as a single file
  class FilePackage
    # @param path [Pathname] path of the file
    def initialize(path)
      fail PackageError, "File not found: #{path}" unless path.exist?

      @file = File.read path
    end

    # Install the package
    #
    # @param user [Boolean] wether or not to install as a user
    def install!(user)
      destination = Pathname.new(@file.options.destination(user)).expand_path

      destination.dirname.mkpath
      destination.open 'w' do |f|
        f.write @file.template.result
      end
    end
  end
end
