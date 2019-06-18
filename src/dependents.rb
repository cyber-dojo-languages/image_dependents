
# Main entry point for cyberdojofoundation/image_dependents docker image.
# The SRC_DIR dir has been volume mounted to /data

require_relative 'circleci'
require 'json'

def dockerfile
  $dockerfile ||= IO.read('/data/Dockerfile')
end

# - - - - - - - - - - - - - - - - -

def from
  from_line = dockerfile.lines.find { |line| line.lstrip.start_with?('FROM') }
  from_line.split[1]
end

# - - - - - - - - - - - - - - - - - - -

def test_framework?
  File.exist?(test_framework_filename)
end

def test_framework_filename
  '/data/start_point/manifest.json'
end

def base_language_filename
  '/data/image_name.json'
end

def image_name
  if test_framework?
    filename = test_framework_filename
  else
    filename = base_language_filename
  end
  content = IO.read(filename)
  JSON.parse(content)['image_name']
end

# - - - - - - - - - - - - - - - - - - -

triple = {
  'from'           => from,
  'image_name'     => image_name,
  'test_framework' => test_framework?
}

puts CircleCI.new(triple).dependents.join(' ')
