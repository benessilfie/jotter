FactoryBot.define do
  factory :note do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    published { false }
    user

    trait :published do
      published { true }
    end
  end

  factory :note2, class: Note do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    published { false }
    user
  end

  factory :user, class: User do
    email { "user@hey.com" }
    password { Faker::Internet.password }
    role { 1 } # default role is member

    trait :admin do
      role { 0 } # set role to admin
    end
  end

  factory :user2, class: User do
    email { "user2@hey.com" }
    password { Faker::Internet.password }
    role { 1 } # default role is member
  end

  factory :other_user, class: User do
    email { "other_user@hey.com" }
    password { Faker::Internet.password }
    role { 1 } # default role is member

    trait :admin do
      role { 0 } # set role to admin
    end
  end

  factory :admin, class: User do
    email { "kofi@hey.com" }
    password { Faker::Internet.password }
    role { 0 } # set role to admin
  end

  factory :admin2, class: User do
    email { "essi@hey.com" }
    password { Faker::Internet.password }
    role { 0 } # set role to admin
  end
end
