namespace :product do
  desc 'Fill price in products without this'

  task fill_price: :environment do |args|
    Product.all.each do |product|
      product.update(price: rand(999)) if product.price.nil?
    end
  end
end
