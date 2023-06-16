FactoryBot.define do
  factory :task do
    title { "1:Factoryで作ったデフォルトのタイトル" }
    detail { "1:Factoryで作ったデフォルトの詳細" }
    expired_at { 7.days.from_now }
    status { 0 }
    priority { 1 }
  end
  factory :second_task, class: Task do
    title { "2:Factoryで作ったデフォルトのタイトル" }
    detail { "2:Factoryで作ったデフォルトの詳細" }
    expired_at { 2.days.from_now }
    status { 1 }
    priority { 0 }
  end
  factory :third_task, class: Task do
    title { "3:Factoryで作ったデフォルトのタイトル" }
    detail { "3:Factoryで作ったデフォルトの詳細" }
    expired_at { 3.days.from_now }
    status { 2 }
    priority { 2 }
  end
end
