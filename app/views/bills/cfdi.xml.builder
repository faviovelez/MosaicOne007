xml.instruct!
xml.tag!(
  'cfdi:Comprobante', {
      "xmlns:cfdi"=>"http://www.sat.gob.mx/cfd/3",
      "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
      "xsi:schemaLocation"=>"http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv33.xsd",
      "Version"=>"3.3",
      "Serie"=> current_user.store.series,
      "Folio"=> current_user.store.last_bill.next,
      "Fecha"=>"2017-06-14T09:09:23",
      "Sello"=>"RMQt7XrXKT22G1xgvz6tGq+5dXElTRTcP7KS4V+D4U2tDK5n3i5WP7zehfG9kh9FhpnVfAY8zv49VD/GcKufwBshIgIRiL9ILwoz0VYL51hh3V7K9cC/aILhapQxqo9AgHDioRYMmVvZXzR7y/4+c8sjCN1fEvfdFWP3+CQv5O1ZEWyjk4UuPj70T65uJFAIkOep5p8XS9ODJhIyWFxJvQDZTbES6qy5Q6aCGwRPy1QsCuxH75r8sz9pfTtlxdza3EFucpGCpDz2fTZto4vGkbBPOB2pgXz3HpqzACQcW1dxhxBpmCw1DL1k5ju59goImZFCxZifsiGp3iRYd5irig==",
      "FormaPago"=>"01",
      "NoCertificado"=>"20001000000300022779",
      "Certificado"=>"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",
      "CondicionesDePago"=>"CONDICIONES",
      "SubTotal"=>"2269400",
      "Moneda"=>"MXN",
      "TipoCambio"=>"1",
      "Total"=>"1436012.00",
      "TipoDeComprobante"=>"I",
      "MetodoPago"=>"PUE",
      "LugarExpedicion"=>"45079"
  }) do
  xml.tag!('cfdi:CfdiRelacionados', {"TipoRelacion"=>"01"}) do
    xml.tag!('cfdi:CfdiRelacionado', {"UUID"=>"A39DA66B-52CA-49E3-879B-5C05185B0EF7"})
  end
  xml.tag!('cfdi:Emisor', {
                          "Rfc"=>"LAHH850905BZ4",
                          "Nombre"=>"HORACIO LLANOS",
                          "RegimenFiscal"=>"608"
                          })
  xml.tag!('cfdi:Receptor', {
                            "Rfc"=>"HEPR930322977",
                            "Nombre"=>"RAFAEL ALEJANDRO HERNÁNDEZ PALACIOS",
                            "UsoCFDI"=>"G01"
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
  xml.tag!('cfdi:Impuestos', {"TotalImpuestosTrasladados"=>"363104"}) do
    xml.tag!('cfdi:Traslados') do
      xml.tag!('cfdi:Traslado', {
                                "Impuesto"=>"002",
                                "TipoFactor"=>"Tasa",
                                "TasaOCuota"=>"0.160000",
                                "Importe"=>"363104"
                                })
    end
  end
  xml.tag!('cfdi:Complemento', {"CadenaOriginal"=>@original_chain})
end
