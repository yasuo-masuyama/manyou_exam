name_admin = "admin1"
email_admin = "admin1@gmail.com"
password_admin = "adminuser"
User.create!(name: name_admin, email: email_admin, password: password_admin, admin: true)

10.times do |user|
  name = Faker::Games::Pokemon.name
  email = Faker::Internet.email
  password = "111111"
  User.create!(name: name, email: email, password: password, admin: false)
end

User.all.each do |user|
  10.times do |task|
    title = Faker::Games::Pokemon.name
    detail = Faker::Internet.email
    expired_at = 5.days.from_now
    status = 1
    priority = 1
    user.tasks.create!(title: title, detail: detail, expired_at: expired_at, status: status, priority: priority)
  end
end

10.times do { |id| Label.create!(id: id, name: Faker::Games::Pokemon.name) }

Task.all.each { |task| task.labellings.create!(task_id: task, label_id: rand(1..10))}
