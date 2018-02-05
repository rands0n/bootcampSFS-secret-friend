FactoryBot.define do
  factory :campaign do
    title { FFaker::Lorem.word }
    description { FFaker::Lorem.sentence }
  end
end