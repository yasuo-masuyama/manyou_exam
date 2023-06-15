FactoryBot.define do
  factory :task do
    title { "1:Factoryで作ったデフォルトのタイトル" }
    detail { "1:Factoryで作ったデフォルトのディティール" }
  end
  factory :second_task, class: Task do
    title { "2:Factoryで作ったデフォルトのタイトル" }
    detail { "2:Factoryで作ったデフォルトのコンテント" }
  end
end
