xml.instruct!
xml.tag!(
  'cfdi:Comprobante', {
      "xmlns:cfdi"=>"http://www.sat.gob.mx/cfd/3",
      "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
      "xsi:schemaLocation"=>"http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv33.xsd",
      "Version"=>"3.3",
      "Serie"=> current_user.store.series,
      "Folio"=> current_user.store.last_bill.next,
      "Fecha"=> Time.now.strftime('%FT%T'),
      "Sello"=>"",
      "FormaPago"=> greatest_payment_key,
      "NoCertificado"=> current_user.store.business_unit.billing_address.certificate_number,
      "Certificado"=>"",
      "CondicionesDePago"=> payment_form,
      "SubTotal"=> subtotal,
      "Moneda"=>"MXN",
      "TipoCambio"=>"1",
      "Total"=> total,
      "TipoDeComprobante"=> @type_of_bill_key,
      "MetodoPago"=> payment_method_key,
      "LugarExpedicion"=> current_user.store.business_unit.billing_address.zipcode,
  }) do
  xml.tag!('cfdi:CfdiRelacionados', {"TipoRelacion"=>"01"}) do
    xml.tag!('cfdi:CfdiRelacionado', {"UUID"=>"A39DA66B-52CA-49E3-879B-5C05185B0EF7"})
  end
  xml.tag!('cfdi:Emisor', {
                          "Rfc"=> store_rfc,
                          "Nombre"=> store_name,
                          "RegimenFiscal"=> tax_regime_key
                          })
  xml.tag!('cfdi:Receptor', {
                            "Rfc"=> prospect_rfc,
                            "Nombre"=> prospect_name,
                            "UsoCFDI"=> @cfdi_use_key
                            })
  xml.tag!('cfdi:Conceptos') do
    xml.tag!('cfdi:Concepto', {
                              "ClaveProdServ"=>"01010101",
                              "NoIdentificacion"=>"00001",
                              "Cantidad"=>"1",
                              "ClaveUnidad"=>"F52",
                              "Unidad"=>"TONELADA",
                              "Descripcion"=>"ACERO",
                              "ValorUnitario"=>"1500000.00",
                              "Importe"=>"2250000.00"
                              }) do
      xml.tag!('cfdi:Impuestos') do
        xml.tag!('cfdi:Traslados') do
          xml.tag!('cfdi:Traslado', {
                                    "Base"=>"2250000",
                                    "Impuesto"=>"002",
                                    "TipoFactor"=>"Tasa",
                                    "TasaOCuota"=>"0.160000",
                                    "Importe"=>"360000"
                                    })
        end
      end
    end
  end
  xml.tag!('cfdi:Impuestos', {"TotalImpuestosTrasladados"=> total_taxes}) do
    xml.tag!('cfdi:Traslados') do
      xml.tag!('cfdi:Traslado', {
                                "Impuesto"=>"002",
                                "TipoFactor"=>"Tasa",
                                "TasaOCuota"=>"0.160000",
                                "Importe"=> total_taxes
                                })
    end
  end
  xml.tag!('cfdi:Complemento', {"CadenaOriginal"=>@original_chain})
end
