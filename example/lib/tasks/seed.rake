task seed: :environment do
  require 'faker'

  Product.delete_all

  100.times do
    Product.create(name: Faker::Name.name)
  end
end
