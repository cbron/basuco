require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'pathname'
require 'json'
require 'matchy'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

TEST_ROOT = Pathname(__FILE__).dirname.expand_path
require TEST_ROOT.parent + 'lib/ken'

def load_fixture(fixture_name)
  fname = "#{File.dirname(__FILE__)}/fixtures/#{fixture_name}.json"
  unless File.exists?(fname)
    open(fname, "w") do |file|
      puts "WARNING: Fixtures could not be loaded."
    end
  end
  JSON.parse open(fname,"r").read
end

class Test::Unit::TestCase
  custom_matcher :be_nil do |receiver, matcher, args|
    matcher.positive_failure_message = "Expected #{receiver} to be nil but it wasn't"
    matcher.negative_failure_message = "Expected #{receiver} not to be nil but it was"
    receiver.nil?
  end

  custom_matcher :have do |receiver, matcher, args|
    count = args[0]
    something = matcher.chained_messages[0].name
    actual = receiver.send(something).size
    actual == count
  end

  custom_matcher :be_true do |receiver, matcher, args|
    matcher.positive_failure_message = "Expected #{receiver} to be true but it wasn't"
    matcher.negative_failure_message = "Expected #{receiver} not to be true but it was"
    receiver.eql?(true)
  end

  custom_matcher :be_false do |receiver, matcher, args|
    matcher.positive_failure_message = "Expected #{receiver} to be false but it wasn't"
    matcher.negative_failure_message = "Expected #{receiver} not to be false but it was"
    receiver.eql?(false)
  end
end

class Object
  # nice for debugging
  # usage: print_call_stack(:method_name, 2, 10)
  def print_call_stack(from = 2, to = nil, html = false)
    (from..(to ? to : caller.length)).each do |idx|
      p "[#{idx}]: #{caller[idx]}#{html ? '<br />' : ''}"
    end
  end
end
