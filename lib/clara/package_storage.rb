require 'clara/utils/abstract'

module Clara
  ##
  # Factory for creating Package storage handlers
  #
  # Packages can be stored in many different ways. Different type of packages need to be handled differently
  # For example, remote packages should be downloaded before being played with. Compressed packages need to
  # be extracted in a temporary work environment before their contents can be accessed.
  module PackageStorage
    @@handlers = []

    ##
    # Create a package storage
    #
    # The
    def self.create(path)
      @@handlers.each do |handler|
        handler.new path if handler.handles? path
      end

      raise Clara::UnsupportedPackageTypeError.new "Could not find handler for #{path}"
    end

    ##
    # Register as a storage handler
    #
    # Automatically called when PackageStorage::Base is inherited
    def self.add_package_storage_handler(handler)
      @@handlers << handler
    end

    ##
    # Abstract Package storage class
    #
    # Classes that inherit this class will handle a certain type of package. e.g. Compressed, remote, etc.
    class Base
      extend Clara::Utils::Abstract

      # register as a handler when inherited
      def self.inherited(subclass)
        Clara::PackageStorage.add_package_storage_handler subclass
      end

      ##
      # Opens the package
      abstract_method :open

      ##
      # returns a File object for the install script
      abstract_method :install_script

      ##
      # returns the package information
      abstract_method :information

      ##
      # returns the path where the files to be installed are located
      abstract_method :files

      ##
      # :singleton-method: handles?
      # :arg: path
      # Method that determines whether or not this handler should handle the +path+ given
      #
      # if the method returns true, its class will be used to handle the package
      abstract_class_methods :handles?
    end
  end

  class UnsupportedPackageTypeError < RuntimeError; end
end
