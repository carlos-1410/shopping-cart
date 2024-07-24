# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    code { "PR-#{random_chars} " }
    name { "My product #{random_chars}" }
    price { 1.23 }
  end
end

def random_chars
  @random_chars ||= SecureRandom.hex(3)
end
