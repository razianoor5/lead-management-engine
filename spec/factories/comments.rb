FactoryBot.define do
  factory :comment do
    association :lead
    association :phase
    body { 'hello' }
  end
end
