require 'erubis'

module Clara
  # An executable ERB template that can be executed to produce and output file
  class Template
    def initialize(erb)
      @erb = Erubis::Eruby.new erb
    end

    def result
      @erb.result
    end
  end
end
