name_admin = "admin1"
email_admin = "admin1@gmail.com"
password_admin = "adminuser"
User.create!(name: name_admin, email: email_admin, password: password_admin, admin: true)
