FactoryBot.define do
  factory :user do
    name { "test_user" }
    email { "test_user@example.com" }
    password { '111111' }
    password_confirmation  { '111111' }
    admin { false }
  end
  factory :second_user, class: User do
    name { "test_user2" }
    email { "test_user2@example.com" }
    password { '111111' }
    password_confirmation  { '111111' }
    admin { false }
  end
  factory :third_user, class: User do
    name { "test_user3" }
    email { "test_user3@example.com" }
    password { '111111' }
    password_confirmation  { '111111' }
    admin { false }
  end
  factory :admin_user1, class: User do
    name { "admin_test_user1" }
    email { "admin_test_user1@example.com" }
    password { '111111' }
    password_confirmation  { '111111' }
    admin { true }
  end
  factory :admin_user2, class: User do
    name { "admin_test_user2" }
    email { "admin_test_user2@example.com" }
    password { '111111' }
    password_confirmation  { '111111' }
    admin { true }
  end
end
