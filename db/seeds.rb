# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(email:"alex@tgg.com", password:"123456", admin:true)
User.create!(email:"francois@tgg.com", password:"123456", admin:true)
User.create!(email:"eytan@tgg.com", password:"123456", admin:true)
User.create!(email:"gauthier@tgg.com", password:"123456", admin:true)
User.create!(email:"new@tgg.com", password:"123456", admin:true)
