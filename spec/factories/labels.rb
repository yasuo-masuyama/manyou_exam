FactoryBot.define do
  factory :label do
    name { "first" }
  end
  factory :second_label, class: Label do
    name { "second" }
  end
  factory :third_label, class: Label do
    name { "third" }
  end
end
