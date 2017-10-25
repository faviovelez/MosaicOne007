class StoresJobsJob < ActiveJob::Base
  queue_as :default

  def perform(store)
    all_products_except_special.each do |product|
      StoresInventory.create(product: product, store: store)
    end
  end

  def all_products_except_special
    suppliers_id = []
    Supplier.where(name: [
                          'Diseños de Cartón',
                          'Comercializadora de Cartón y Diseño'
                          ]).each do |supplier|
                            suppliers_id << supplier.id
                          end
    Product.where(supplier: suppliers_id).where.not(classification: ['especial', 'de tienda'])
  end

end
