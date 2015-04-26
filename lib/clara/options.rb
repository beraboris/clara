module Clara
  # Package options
  class Options
    def initialize(hash)
      @hash = hash
    end

    def [](key)
      @hash[key]
    end

    # @return [String] The install destination
    # @param user [Boolean] wether or not to return the user location
    def destination(user)
      if user
        self['user_location']
      else
        self['system_location']
      end
    end

    # @return [Boolean] wether or there are any options
    def empty?
      @hash.empty?
    end
  end
end
