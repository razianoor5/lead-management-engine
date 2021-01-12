# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body { Faker::Quote.robin }
  end
end
