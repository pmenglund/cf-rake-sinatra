if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter "/features/"
  end
end

ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), '..', '..', 'app.rb')

require 'capybara'
require 'capybara/cucumber'
require 'rspec'

Capybara.app = Sinatra::Application

World do
  include Capybara::DSL
  include RSpec::Expectations
  include RSpec::Matchers
end
