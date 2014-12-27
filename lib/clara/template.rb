require 'erubis'

module Clara
  class Template
    def initialize(erb)
      @erb = Erubis::Eruby.new erb
    end

    def result
      @erb.result
    end
  end
end