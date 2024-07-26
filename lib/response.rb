# frozen_string_literal: true

class Response
  class ValueError < StandardError; end

  attr_reader :value, :meta

  def self.success(value, options = {})
    new(success: true, value: value, meta: options[:meta] || {})
  end

  def self.failure(value, options = {})
    new(success: false, value: value, meta: options[:meta] || {})
  end

  def initialize(success:, value: nil, meta: {})
    @success = success
    @value = value
    @meta = meta || {}
  end

  def success?
    @success == true
  end

  def failure?
    !success?
  end

  def on_success
    yield(value) if success?

    self
  end

  def on_failure
    return self if success?

    yield(value)
    self
  end

  def ==(other)
    value == other.value && success? == other.success?
  end
end
