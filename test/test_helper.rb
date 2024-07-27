# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "minitest/mock"
require "mocha/minitest"
require "rails/test_help"
require "./test/support/query_counter_helper"

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
