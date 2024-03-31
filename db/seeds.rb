# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create!(
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password',
  name: 'Admin User',
  role: 'admin'
)

User.create!(
  email: 'user1@example.com',
  password: 'password',
  role: 'user',
  region: 'Region 1'
)

User.create!(
  email: 'user2@example.com',
  password: 'password',
  role: 'user',
  region: 'Region 2'
)

# Определяем статусы
statuses = %w[draft pending approved rejected]

# Для каждого пользователя создаем посты с разными статусами
User.all.each do |user|
  statuses.each do |status|
    Post.create!(
      title: "Post with status #{status}",
      content: "Content for post with status #{status}",
      status: status,
      user_id: user.id,
      region: user.region
    )
  end
end
