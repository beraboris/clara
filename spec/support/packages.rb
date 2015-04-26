require 'yaml'
require 'pathname'

# Creates a single file package on the file system
#
# @param path [Pathname] where to dump the file
# @param content [String] the contents of the file
# @param options [Hash] the contents of the yaml header for the file
def make_file_package(path, content, options = {})
  path.dirname.mkpath

  path.open('w') do |f|
    if options.any?
      f.puts stringify_hash_keys(options).to_yaml
      f.puts '---'
    end

    f.puts content
  end
end

def stringify_hash_keys(hash)
  assoc = hash.map do |k, v|
    v = stringify_hash_keys(v) if v.is_a? Hash
    [k.to_s, v]
  end

  Hash[assoc]
end
