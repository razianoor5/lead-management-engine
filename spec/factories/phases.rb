FactoryBot.define do
  factory :phase do
    association :lead

    phase_type { 'Test' }
    assignee { Faker::Internet.safe_email }
    start_date { Faker::Date.between(from: '2020-12-11', to: '2020-12-22') }
    due_date { Faker::Date.between(from: '2020-12-23', to: '2020-12-30') }

    transient do
      languages_count { 2 }
    end

    trait :with_users do
      after :create do |phase|
        phase.users = create_list(:user, 5, :engineer)
      end
    end
    trait :with_comments do
      after :create do |phase|
        phase.comments.create({ body: 'hello' })
      end
    end
  end
end
