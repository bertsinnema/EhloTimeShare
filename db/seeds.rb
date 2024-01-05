# db/seeds.rb

# Create ShareableLocations
location1 = Location.create(name: 'NNAC', address: 'Machlaan 32', zipcode: '9761 TK', city: 'Eelde')
location2 = Location.create(name: "Bert's klushol", address: 'Troch de Koer 20', zipcode: '9033 WM', city: 'Deinum')

# Create ShareableItems for location1
location1.items.create(name: 'Cessna 172 Skyhawk')
location1.items.create(name: 'Cessna 172 Skyhawk')

# Create ShareableItems for location2
location2.items.create(name: 'Laptop')
location2.items.create(name: 'Momentsleutel')
location2.items.create(name: 'Remlauw terugdraaiset')

puts 'Seed data created successfully!'