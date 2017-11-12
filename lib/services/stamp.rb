require 'savon'
require 'rubygems'
require 'base64'

def stamp_pac
  #Crea un cliente SOAP con Savon
  client = Savon.client(wsdl: "https://demo-facturacion.finkok.com/servicios/soap/stamp.wsdl")

  #Carga el XML para ser timbrado
  file = File.read(@working_path.join('unsigned.xml')) ## CAMBIAR A UNSTAMPED CUANDO SEAN EXITOSAS LAS PRUEBAS

  #Cifra el XML en Base64
  xml_file = Base64.encode64(file)

  #Correo y contraseña de acceso al panel de FINKOK
  username = ENV['username_pac']
  password = ENV['password_pac']

  #Envia la peticion al webservice de timbrado
  ops = client.operation(:sign_stamp) ##CAMBIAR A STAMP CUANDO SEAN EXITOSAS LAS PRUEBAS
  request = ops.build(message: { xml: xml_file, username: username , password: password })

  #Obtiene el SOAP Request y lo guarda en un archivo
  response = client.call(:sign_stamp, message: { xml: xml_file, username: username , password: password })
  response_hash = response.hash

  # Resume el método para llamar las distintas partes del hash del webservice
  hash = response_hash[:envelope][:body][:sign_stamp_response][:sign_stamp_result]

  #Separa los métodos según las partes que se necesitan
  xml_response = hash[:xml]
  @uuid = hash[:uuid]
  @date = hash[:fecha]
  @cod_status = hash[:cod_estatus]
  @sat_seal = hash[:sat_seal]
  @sat_certificate = hash[:no_certificado_sat]
  @incidents_hash = hash[:incidencias]

  #Separa la parte del timbre fiscal digital para generar cadena original (y quita la parte que genera error)
  doc = Nokogiri::XML(xml_response)
  extract = doc.xpath('//cfdi:Complemento').children.to_xml.gsub('xsi:', '')

  #Obtiene el atributo SelloCFD
  @cfd_stamp = doc.xpath('//cfdi:Complemento').children.attr('SelloCFD').value

  #Obtiene los últimos 8 dígitos del atributo SelloCFD (para QR)
  @cfd_last_8 = @cfd_stamp.slice((@cfd_stamp.length - 8)..@cfd_stamp.length)

  #Guarda en XML el archivo timbrado del PAC
  stamped_xml = File.open(File.join(@final_dir, 'stamped.xml'), 'w'){ |file| file.write(xml_response) }

  #Guarda el extracto del timbre fiscal digital en un XML
  extract_xml = File.open(File.join(@working_dir, 'tfd.xml'), 'w'){ |file| file.write(extract) }

  #Transforma el XML del timbre fiscal digital en una cadena original usando el xslt del SAT
  stamp_xml = Nokogiri::XML(File.read(@working_path.join('tfd.xml')))
  stamp_xslt = Nokogiri::XSLT(File.read(@sat_path.join('cadenaoriginal_TFD_1_1.xslt')))
  @stamp_original_chain = stamp_xslt.apply_to(stamp_xml)
end

def cancel_finkok
  #Crea un cliente SOAP con Savon
  client = Savon.client(wsdl: 'https://demo-facturacion.finkok.com/servicios/soap/cancel.wsdl')

  username = ENV['username_pac']
  password = ENV['password_pac']
  taxpayer_id = "AAD990814BP7" #RFC Emisor
  invoice = 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX' #UUID a cancelar

  #Convierte a formato PEM el archivo ".cer"
  #Convierte a formato PEM el archivo ".key"
  #Encriptar con DES3 el archivo ".key.pem"

  uuid = [invoice]
  uuid.map! do |uuid|
      uuid = "<tns:string>#{uuid}</tns:string>"
  end

  xml = <<XML
<tns:UUIDS>
      <tns:uuids>
#{uuid.join "\n"}
      </tns:uuids>
</tns:UUIDS>
<tns:username>#{username}</tns:username>
<tns:password>#{password}</tns:password>
<tns:taxpayer_id>#{taxpayer_id}</tns:taxpayer_id>
<tns:cer>#{cer_pem_b64}</tns:cer>
<tns:key>#{key_des3_b64}</tns:key>
XML

  #Envia la peticion al webservice de cancelacion
  response = client.call(:cancel, message: xml )

  #Obtiene el SOAP Request y lo guarda en un archivo
  ops = client.operation(:cancel)
  request = ops.build(message: xml )

  File.open("/ruta/donde/guardar/SOAP_Request_cancel.xml", "w") do |file|
      file.write(request)
  end

  #Obtener SOAP Response y lo guarda en un archivo
  File.open("/ruta/donde/guardar/SOAP_Response_cancel.xml", "w") do |file|
      file.write(response)
  end
end



def get_certificate
  # Obtener el certificado y codificarlo en base 64
  cer_file = File.open(Rails.root.join('lib', 'cer', '2', 'LAN7008173R5.cer'))
  b64 = Base64.encode64(File::read(cer_file))

  # Guardar el certificado en base 64 (posiblemente no necesito escribir un archivo, solo el string de b64)
  File.open((Rails.root.join('lib', 'cer', '2', 'cer.pem')), "w") do |file|
    file.write(b64)
  end

  new_file = File.read(Rails.root.join('lib', 'cer', '2', 'LAN7008173R5.cer'))
  translate = OpenSSL::X509::Certificate.new new_file

  translate = OpenSSL::BN.new

  pem_file = File.read(Rails.root.join('lib', 'cer', '2', 'LAN7008173R5.key'))
  translate = Base64.strict_encode64(pem_file)
  translate = OpenSSL::PKey::RSA.new(Base64.strict_encode64(pem_file), '12345678a')

  translate = OpenSSL::PKey::RSA.new(pem_file, '12345678a')

  certificate = translate.serial

  cer_file = File.open(Rails.root.join('lib', 'cer', '2', 'LAN7008173R5.cer'))
  der = File.binread(cer_file)

end

def box(tag, lines)
  lines.unshift "-----BEGIN #{tag}-----"
  lines.push "-----END #{tag}-----"
  lines.join("\n")
end

def der_to_pem(tag, der)
  box tag, Base64.strict_encode64(der).scan(/.{1,64}/)
end

def trash
  pem = der_to_pem('PRIVATE KEY', File.read(Rails.root.join('lib', 'cer', '2', 'LAN7008173R5.key')))
  key = OpenSSL::PKey::RSA.new(file, '12345678a')

  pem2 = der_to_pem('ENCRYPTED PRIVATE KEY', File.read(Rails.root.join('lib', 'cer', '2', 'LAN7008173R5.key')))
  key2 = OpenSSL::PKey.new(pem2, '12345678a')
end
