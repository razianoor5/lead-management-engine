# frozen_string_literal: true

FactoryBot.define do
  factory :lead do
    association :user

    project_name { Faker::Team.name }
    client_name { Faker::Name.first_name }
    client_address { Faker::Address.city }
    client_email { Faker::Internet.safe_email }
    client_contact { '03497847665' }
    platform_used { 'abc' }

    trait :with_phases do
      after :create do |lead|
        phases = FactoryBot.create_list :phase, 2, :with_users
        lead.phases << phases
        lead.save!
      end
    end

    trait :with_phase_comments do
      after :create do |lead|
        phases = FactoryBot.create_list :phase, 2, :with_comments
        lead.phases << phases
        lead.save
      end
    end

    trait :with_comments do
      after :create do |lead|
        lead.comments.create({ body: 'hello' })
      end
    end

    trait :with_empty_city do
      client_address { '' }
    end
  end
end
