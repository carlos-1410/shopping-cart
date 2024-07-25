# frozen_string_literal: true

require "test_helper"

class ResponseTest < ActiveSupport::TestCase
  test "response are equal" do
    response_one   = Response.success(1)
    response_two   = Response.success(1)

    assert_equal response_one, response_two
  end

  test "response are different due the value" do
    response_one   = Response.success(1)
    response_two   = Response.success(2)

    assert_not_equal response_one, response_two
  end

  test "response are different due the the sucess" do
    response_one   = Response.success(1)
    response_two   = Response.failure(1)

    assert_not_equal response_one, response_two
  end

  test "success builder" do
    response = Response.success(value_response)

    assert response.success?
    assert_equal response.value, value_response
  end

  test "failure builder" do
    response = Response.failure(value_response)

    assert response.failure?
    assert_equal response.value, value_response
  end

  test "syntaxt suggar initializer" do
    response = Response.success(value_response)

    assert response.is_a?(Response)
  end

  test "success is true with true as parameter" do
    response = Response.new(success: true, value: value_response)

    assert response.success?
    assert_not response.failure?
    assert_equal value_response, response.value
  end

  test "success is false with false as parameter" do
    response = Response.new(success: false, value: value_response)

    assert_not response.success?
    assert response.failure?
    assert_equal value_response, response.value
  end

  test "success is false with non true as parameter" do
    response = Response.new(success: "true", value: value_response)

    assert_not response.success?
    assert response.failure?
    assert_equal value_response, response.value
  end

  test "on failure not excuted if success" do
    on_failure_executed = false

    Response
      .success("ok")
      .on_failure { on_failure_executed = true }

    assert_not on_failure_executed
  end

  test "on failure excuted if failure" do
    on_failure_executed = false

    Response
      .failure("error")
      .on_failure { on_failure_executed = true }

    assert on_failure_executed
  end

  test "on failure does not change the response" do
    response = Response
      .failure("error")
      .on_failure { Response.success("ok") }

    assert response.failure?
  end

  test "on success returns original response" do
    original_response = Response.success("ok")
    on_success_response = original_response.on_success { "on success output" }

    assert_equal original_response, on_success_response
  end

  test "on success runs block on previous success" do
    on_success_executed = false

    Response
      .success("ok")
      .on_success { on_success_executed = true }

    assert on_success_executed, "on_success block should have executed when successful."
  end

  test "on success does not execute on failure" do
    on_success_executed = false

    Response
      .failure("error")
      .on_success { on_success_executed = true }

    assert_not on_success_executed, "on_success block shouldn't have executed when failed."
  end

  private

  def value_response
    "whatever"
  end
end
