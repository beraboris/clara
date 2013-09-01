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
        return handler.new path if handler.handles? path
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
      # register as a handler when inherited
      def self.inherited(subclass)
        Clara::PackageStorage.add_package_storage_handler subclass
      end
    end
  end

  class UnsupportedPackageTypeError < RuntimeError; end
end
