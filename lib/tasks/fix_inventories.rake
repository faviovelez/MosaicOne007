desc 'Fix inventories'

task fix_inventories: :environment do
  Store.where.not(store_type: 2).each do |store|
    store_id = store.id
    products = Product.where("(classification = 'de línea' OR classification = 'especial') AND child_id is NULL OR store_id = #{store_id}").order(:id).pluck(:id)
    inventories = StoresInventory.where(store: store).order(:id).pluck(:product_id)
    products_without_inv = products - inventories
    products_without_inv.each do |prod|
      if StoresInventory.where(store: store, product_id: prod).count < 1
        StoresInventory.create(store: store, product_id: prod)
      end
    end
  end

  StoresInventory.where(store_id: 1).find_each do |inv|
    inv.delete
  end

  Store.where(store_type: 2).each do |store|
    store_id = store.id
    products = Product.where("(classification = 'de línea' OR classification = 'especial') OR store_id = #{store_id}").order(:id).pluck(:id)
    if store_id == 2
      inventories = StoresInventory.where(store: store).order(:id).pluck(:product_id)
      products_without_inv = products - inventories
      products_without_inv.each do |prod|
        if StoresInventory.where(store: store, product_id: prod).count < 1
          StoresInventory.create(store: store, product_id: prod)
        end
      end
    else
      inventories = Inventory.all.order(:id).pluck(:product_id)
      products_without_inv = products - inventories
      products_without_inv.each do |prod|
        if Inventory.where(product_id: prod).count < 1
          Inventory.create(product_id: prod)
        end
      end
    end
  end
end
