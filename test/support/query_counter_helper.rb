# frozen_string_literal: true

module QueryCounterHelper
  module_function

  def select_queries_amount
    counter = 0

    callback = lambda do |_name, _started, _finished, _callback_id, payload|
      next if internal_rails_query?(payload)

      counter += 1 if payload[:sql].starts_with?("SELECT ")
    end

    ActiveSupport::Notifications.subscribed(callback, "sql.active_record") do
      yield

      counter
    end
  end

  def internal_rails_query?(payload)
    payload[:name] == "SCHEMA" ||
      payload[:sql].starts_with?("SELECT DISTINCT") || payload[:sql].starts_with?("SELECT COUNT(*)")
  end
end
