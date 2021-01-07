# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.safe_email }
    password { Faker::Internet.password(min_length: 6) }
    role { 'business_developer' }
    name { Faker::Name.name }
  end
end
