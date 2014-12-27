require 'boson/runner'
require 'safe_yaml'
require 'erubis'

module Clara
  class Runner < Boson::Runner
    option :system, type: :boolean, desc: 'system wide install', default: false
    option :user, type: :boolean, desc: 'user install', default: true
    def install(package, options = {})
      raw_contents, package_options = extract_file_options(package)
      contents = Erubis::Eruby.new(raw_contents).result

      location = user_install?(options) ? package_options['user_location'] : package_options['system_location']
      FileUtils.mkpath File.dirname(location)
      File.write location, contents
    end

    private

    def user_install?(options)
      options[:user] && !options[:system]
    end

    def extract_file_options(file)
      raw_content = File.read file
      match = raw_content.match /\A---\s*\n(.*)\n---\s*\n/m

      if match
        raw_options = match[1]
        # noinspection RubyResolve
        options = SafeYAML.load raw_options
        content = match.post_match

        [content, options]
      else
        [raw_content, {}]
      end
    end
  end
end