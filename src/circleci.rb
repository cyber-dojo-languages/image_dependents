require_relative 'assert_system'
require_relative 'failed'
require_relative 'print_to'
require 'json'

class CircleCI

  def initialize(triple)
    @triple = triple
    unless validated?
      print_to STDERR, *triple_diagnostic
      exit false
    end
  end

  def dependents
    triples.keys.select { |key| triples[key]['from'] == image_name }
  end

  private

  attr_reader :triple

  include AssertSystem
  include Failed
  include PrintTo

  # - - - - - - - - - - - - - - - - - - - - -

  def image_name
    triple['image_name']
  end

  def from
    triple['from']
  end

  def test_framework?
    triple['test_framework']
  end

  # - - - - - - - - - - - - - - - - - - - - -

  def validated?
    found = triples.find { |_,tri| tri['image_name'] == image_name }
    if found.nil?
      return false
    end
    # TODO: check if > 1 found
    found[1]['from'] == from &&
      found[1]['test_framework'] == test_framework?
  end

  # - - - - - - - - - - - - - - - - - - - - -

  def triples
    @triples ||= json_parse("#{__dir__}/dependents.json")
  end

  def triple_diagnostic
    [ '',
      'dependents.json',
      'does not contain an entry for:',
      '',
      "#{quoted('REPO')}: {",
      "  #{quoted('from')}: #{quoted(from)},",
      "  #{quoted('image_name')}: #{quoted(image_name)},",
      "  #{quoted('test_framework')}: #{test_framework?}",
      '},',
      ''
    ]
  end

  # - - - - - - - - - - - - - - - - - - - - -

  def quoted(s)
    '"' + s.to_s + '"'
  end

  # - - - - - - - - - - - - - - - - - - - - -

  def json_parse(filename)
    begin
      content = IO.read(filename)
      JSON.parse(content)
    rescue JSON::ParserError
      failed "error parsing JSON file:#{filename}"
    end
  end

end
