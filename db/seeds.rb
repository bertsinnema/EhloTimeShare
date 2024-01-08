# db/seeds.rb

#Create Users
user1 = User.create(name: 'Alice Aero', email: 'alice@gmail.com', password: 'letmein', password_confirmation:'letmein')
user2 = User.create(name: 'Bob Tool', email: 'bob@gmail.com', password: 'letmein', password_confirmation:'letmein')
user3 = User.create(name: 'Bill Mcloud', email: 'bill@gmail.com', password: 'letmein', password_confirmation:'letmein')

# Create Locations
location1 = Location.create(name: 'Aero Club Groningen', street: 'Machlaan 32', zipcode: '9761 TK', city: 'Eelde', country: "The Netherlands", public: false)
location1.user_locations.create(user: user1, role: "owner")
location1.user_locations.create(user: user2, role: "manager")

location2 = Location.create(name: "Bill's mancave", street: 'Frouwesan 1', zipcode: '8939 EP WM', city: 'Leeuwarden', country: "The Netherlands", public: true)
location2.user_locations.create(user: user2, role: "owner")

# Create Items for location1
location1.items.create(name: 'Cessna 172 Skyhawk')
location1.items.create(name: 'Cirrus SR22 GTS')

# Create Items for location2
location2.items.create(name: 'Laptop')
location2.items.create(name: 'Wrench')
location2.items.create(name: 'Pipe cutter')

puts 'Seed data created successfully!'