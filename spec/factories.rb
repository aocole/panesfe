FactoryGirl.define do

  factory :user do
    uid { Faker::Number.number(10) }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    provider 'google_oauth2'
    given_name { Faker::Name.first_name }
    family_name { Faker::Name.last_name }
  end

  factory :theme do
    association :user, strategy: :build
    name { Faker::Commerce.product_name }
  end

  factory :slideshow do
    name { Faker::Commerce.product_name }
    theme
    association :user, strategy: :build
  end
  
  factory :foldershow do
    name { Faker::Commerce.product_name }
    # order of user and folder_zip matters - must have a user before "uploading"
    association :user, strategy: :build
    folder_zip { File.open(Rails.root.join('seed/folder_zips/hello_world.zip')) }
  end
  
end
