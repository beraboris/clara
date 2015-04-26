require 'safe_yaml'
require 'clara/template'

module Clara
  # A file with a possible yaml header that can be turned into a template
  class File
    attr_reader :options

    def self.read(path)
      new ::File.read path
    end

    # @param [String] content the raw contents of the file
    def initialize(content)
      match = content.match(/\A---\s*\n(.*)\n---\s*\n/m)

      if match
        @options = SafeYAML.load match[1]
        @content = match.post_match
      else
        @options = {}
        @content = content
      end
    end

    def template
      Template.new @content
    end
  end
end
