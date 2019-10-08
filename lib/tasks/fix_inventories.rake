desc 'Fix inventories'

task fix_inventories: :environment do

  Store.where.not(store_type: 2).each do |store|
    store_id = store.id
    products = Product.where("(classification = 'de línea' OR classification = 'especial') AND child_id is NULL OR store_id = #{store_id}").order(:id).pluck(:id)
    products.each do |product|
      if StoresInventory.where(store: store, product_id: product).count < 1
        StoresInventory.create(store: store, product_id: product)
      end
    end

    inventories = StoresInventory.where(store: store).order(:id)
    bad_inventories = []

    inventories.each do |inv|
      if !products.include?(inv.product_id)
        bad_inventories << inv
      end
    end

#    bad_inventories.each do |inv|
#      inv.delete
#    end
  end

  StoresInventory.where(store_id: 1).find_each do |inv|
    inv.delete
  end


  Store.where(store_type: 2).each do |store|
      store_id = store.id
      products = Product.where("(classification = 'de línea' OR classification = 'especial') OR store_id = #{store_id}").order(:id).pluck(:id)
    if store_id == 2
      products.each do |product|
        if StoresInventory.where(store: store, product_id: product).count < 1
          StoresInventory.create(store: store, product_id: product)
        end
      end
      inventories = StoresInventory.where(store: store).order(:id)
    else
      products.each do |product|
        if Inventory.where(product_id: product).count < 1
          Inventory.create(product_id: product)
        end
      end
      inventories = Inventory.all.order(:id)
    end

    bad_inventories = []

    inventories.each do |inv|
      if !products.include?(inv.product_id)
        bad_inventories << inv
      end
    end

#    bad_inventories.each do |inv|
#      inv.delete
#    end
  end
end
