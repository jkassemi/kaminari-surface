task seed: :environment do
  require 'faker'

  Product.delete_all

  6.times do
    Product.create(name: Faker::Commerce.product_name)
  end
end
