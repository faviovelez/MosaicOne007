require 'savon'
require 'rubygems'
require 'base64'


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

  pem_file = File.open(Rails.root.join('lib', 'cer', '2', 'cer.pem'))
  translate = OpenSSL::X509::Certificate.new pem_file

  certificate = translate.serial

  cer_file = File.open(Rails.root.join('lib', 'cer', '2', 'LAN7008173R5.cer'))
  der = File.binread(cer_file)

end

def stamp_pac
  #Crea un cliente SOAP con Savon
  client = Savon.client(wsdl: "https://demo-facturacion.finkok.com/servicios/soap/stamp.wsdl")

  #Carga el XML para ser timbrado
  file = File.open((Rails.root.join('lib', 'sat', 'test.xml')), "r")
  xml = file.read

  #Cifra el XML en Base64
  xml_file = Base64.encode64(xml)

  #Correo y contraseña de acceso al panel de FINKOK
  username = ENV['username_pac']
  password = ENV['password_pac']

  #Envia la peticion al webservice de timbrado
  ops = client.operation(:sign_stamp)
  request = ops.build(message: { xml: xml_file, username: username , password: password })

  #Obtiene el SOAP Request y lo guarda en un archivo
  response = client.call(:sign_stamp, message: { xml: xml_file, username: username , password: password })
  response_hash = response.hash

  # Resume el método para llamar las distintas partes del hash del webservice
  hash = response_hash[:envelope][:body][:sign_stamp_response][:sign_stamp_result]

  #Separa los métodos según las partes que se necesitan
  @xml_response = hash[:xml]
  @uuid = hash[:uuid]
  @date = hash[:fecha]
  cod_status = hash[:cod_estatus]
  @sat_seal = hash[:sat_seal]
  @sat_certificate = hash[:no_certificado_sat]
  incidents_hash = hash[:incidencias]

  #Separa la parte del timbre fiscal digital para generar cadena original (y quita la parte que genera error)
  doc = Nokogiri::XML(xml_response)
  extract = doc.xpath('//cfdi:Complemento').children.to_xml.gsub('xsi:', '')

  #Guarda el extracto del timbre fiscal digital en un XML
  File.open((Rails.root.join('public', 'response', 'extract_to_o_c_1_1.xml')), "w") do |file|
    file.write(extract)
  end

  #Transforma el XML del timbre fiscal digital en una cadena original usando el xslt del SAT
  stamp_xml = Nokogiri::XML(File.read(Rails.root.join('public', 'response', 'extract_to_o_c_1_1.xml')))
  stapm_xslt = Nokogiri::XSLT(File.read(Rails.root.join('lib', 'sat', 'cadenaoriginal_TFD_1_1.xslt')))
  @stamp_original_chain = stapm_xslt.apply_to(stamp_xml)

  #Guarda la petición hecha al WS en un archivo (PENDIENTE SABER SI SE QUEDA)
  File.open((Rails.root.join('public', 'request', 'SOAP_Request_stamp.xml')), "w") do |file|
    file.write(request)
  end

  #Obtiene todo el contenido del SOAP Response y lo guarda en un archivo (PENDIENTE SABER SI SE QUEDA)
  File.open((Rails.root.join('public', 'response', 'SOAP_Response_stamp.xml')), "w") do |file|
    file.write(response_hash)
  end

  #Obtiene el XML del SOAP Response y lo guarda en un archivo
  File.open((Rails.root.join('public', 'response', 'SOAP_xml_Response_stamp.xml')), "w") do |file|
    file.write(xml_response)
  end

end
