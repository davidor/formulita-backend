$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simplecov'
SimpleCov.start

require 'formulita_backend'
require 'webmock/rspec'

def fixtures_path
  "#{File.expand_path File.dirname(__FILE__)}/fixtures/"
end
