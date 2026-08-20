puts "Clearing existing data..."
OrderItem.destroy_all
Order.destroy_all
Product.destroy_all
Category.destroy_all

puts "Creating categories..."
knives   = Category.create!(name: "Knives",   description: "Hand-forged carbon steel blades.")
tools    = Category.create!(name: "Tools",    description: "Workshop and garden tools built to last.")
hardware = Category.create!(name: "Hardware", description: "Forged hooks, brackets, and fittings.")

puts "Creating products..."
Product.create!([
  { name: "Chef's Knife",      description: "8-inch high-carbon steel chef's knife with a stabilized oak handle.", price: 189.00, stock: 8,  category: knives },
  { name: "Paring Knife",      description: "Nimble 3.5-inch blade for detail work.",                              price: 89.00,  stock: 15, category: knives },
  { name: "Cleaver",           description: "Heavy full-tang cleaver for breaking down cuts.",                     price: 145.00, stock: 5,  category: knives },
  { name: "Claw Hammer",       description: "Forged 16oz head on a hickory handle.",                               price: 62.00,  stock: 20, category: tools },
  { name: "Hand Axe",          description: "Compact camp axe with a leather sheath.",                             price: 118.00, stock: 7,  category: tools },
  { name: "Garden Trowel",     description: "One-piece forged trowel that won't bend.",                            price: 44.00,  stock: 25, category: tools },
  { name: "Wall Hook",         description: "Blacksmith-forged iron hook. Set of two.",                            price: 28.00,  stock: 40, category: hardware },
  { name: "Shelf Bracket",     description: "Heavy L-bracket for reclaimed timber shelving.",                      price: 36.00,  stock: 30, category: hardware },
  { name: "Gate Latch",        description: "Traditional thumb latch in blackened steel.",                         price: 54.00,  stock: 12, category: hardware }
])

puts "Done. #{Category.count} categories, #{Product.count} products."