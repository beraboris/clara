module Clara
  # Package options
  class Options
    def initialize(hash)
      @hash = hash
    end

    def [](key)
      @hash[key]
    end

    # @return The install destination
    # @param [Boolean] user wether or not to return the user location
    def destination(user)
      if user
        self['user_location']
      else
        self['system_location']
      end
    end
  end
end
