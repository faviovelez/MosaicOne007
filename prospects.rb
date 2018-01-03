prospects = Prospect.where(billing_address: nil)
prospects.each do |prospect|
  billing = BillingAddress.find_by_business_name(prospect.legal_or_business_name)
  prospect.update(billing_address: billing)
  unless billing == nil
    if billing.store != nil
      prospect.update(store: billing.store)
    end
  end
end


# Para los que no encuentre, cambiar Lapizlázuli por los otros. Posiblemente estos:

# new_stores = [
#   'Cuautitlán',
#   'Lapizlázuli',
#   'Roble',
#   'San Juan Bosco',
#   'Cruz del sur'
# ]

  csv_text = File.read(Rails.root.join('public', 'prospect_files', "LayOutClientesLapiz.csv"))
  csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')

  csv.each do |row|
    prospects = Prospect.where(legal_or_business_name: row['nombre_de_empresa_o_cliente'])

    prospects.each do |prospect|
      prospect.delete
    end

    billings = BillingAddress.where(business_name: row['nombre_de_empresa_o_cliente'])

    billings.each do |billing|
      billing.delete
    end

    billing = BillingAddress.create(
                                    {
                                      business_name: row['nombre_de_empresa_o_cliente'],
                                      rfc: row['rfc'],
                                      street: row['calle'],
                                      exterior_number: row['num_ext'],
                                      interior_number: row['num_num'],
                                      zipcode: row['cod_postal'],
                                      neighborhood: row['colonia'],
                                      city: row['ciudad'],
                                      state: row['estado'],
                                      store: Store.find_by_store_name('Lapizlázuli')
                                    }
                                  )
    prospect = Prospect.find_or_create_by(
                                {
                                  legal_or_business_name: row['nombre_de_empresa_o_cliente'],
                                  prospect_type: row['giro'],
                                  contact_first_name: row['contacto_primer_nombre'],
                                  contact_middle_name: row['contacto_segundo_nombre'],
                                  contact_last_name: row['contacto_apellido_paterno'],
                                  second_last_name: row['contacto_apellido_materno'],
                                  contact_position: row['puesto_del_contacto'],
                                  direct_phone: row['tel_fijo'],
                                  extension: row['ext'],
                                  cell_phone: row['cel'],
                                  email: row['mail'],
                                  store: Store.find_by_store_name('Lapizlázuli'),
                                  billing_address: billing
                                }
                              )
  end
