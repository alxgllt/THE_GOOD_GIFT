require 'csv'

csv_text = File.read(Rails.root.join('lib', 'seeds', 'products.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  Product.create!(row.to_hash)
end

User.create!(email:"alex@tgg.com", password:"123456", admin:true)
User.create!(email:"francois@tgg.com", password:"123456", admin:true)
User.create!(email:"eytan@tgg.com", password:"123456", admin:true)
User.create!(email:"gauthier@tgg.com", password:"123456", admin:true)
User.create!(email:"new@tgg.com", password:"123456", admin:true)


# csv.each do |row|
#   Product.create!
#     name: row['name']
#     brand: row['brand']
#     image: row['image']
#     price: row['price']
#     description: row['description'
#     description_short: row['description_short']
#     gender: row['gender']
#     tag_one: row['tag_one']
#     tag_two: row['tag_two']
#     sell_priority: row['sell_priority']
#     supplier_name: ow['supplier_name']
#     stock: row['stock']
#     availability: row['availability']
#     online_supplied: row['online_supplied']
# end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

