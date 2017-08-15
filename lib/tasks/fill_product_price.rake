namespace :product do
  desc 'Fill price in products without this'

  task fill_price: :environment do |args|
    Product.all.each do |product|
      product.price = rand(999) if product.price.nil?
      unless product.save(validate: false)
        binding.pry
      end
    end
  end
end
