require 'webmock/rspec'
require File.expand_path '../../emailer.rb', __FILE__

ENV['RACK_ENV'] = 'test'

RSpec::Expectations.configuration.warn_about_potential_false_positives = false
