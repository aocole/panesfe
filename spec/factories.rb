FactoryGirl.define do

  factory :user do
    uid { Faker::Number.number(10) }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    provider 'google_oauth2'
  end

  factory :theme do
    association :user, strategy: :build
    name { Faker::Commerce.product_name }
  end

  factory :presentation do
    name { Faker::Commerce.product_name }
    theme
    association :user, strategy: :build
  end
  
end
