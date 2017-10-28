require 'savon'
require 'rubygems'
require 'base64'
require 'cgi'

def stamp_finkok
  #Crea un cliente SOAP con Savon
  client = Savon.client(wsdl: "https://demo-facturacion.finkok.com/servicios/soap/stamp.wsdl")

  #Carga el XML para ser timbrado
  file = File.open((Rails.root.join('lib', 'sat', 'test.xml')), "r")

  xml = file.read

  #Cifra el XML en Base64
  xml_file = Base64.encode64(xml)

  #Correo de acceso al panel de FINKOK
  username = "favio.velez@hotmail.com"

  #Contraseña de acceso al panel de FINKOK
  password = ENV['finkok']

  #Envia la peticion al webservice de timbrado
  ops = client.operation(:sign_stamp)
  request = ops.build(message: { xml: xml_file, username: username , password: password })

  #Obtiene el SOAP Request y lo guarda en un archivo
  response = client.call(:sign_stamp, message: { xml: xml_file, username: username , password: password })
  response_hash = response.hash
  xml_response = response_hash[:envelope][:body][:sign_stamp_response][:sign_stamp_result][:xml]
  uuid = response_hash[:envelope][:body][:sign_stamp_response][:sign_stamp_result][:uuid]
  date = response_hash[:envelope][:body][:sign_stamp_response][:sign_stamp_result][:fecha]
  cod_status = response_hash[:envelope][:body][:sign_stamp_response][:sign_stamp_result][:cod_status]
  sat_seal = response_hash[:envelope][:body][:sign_stamp_response][:sign_stamp_result][:sat_seal]
  sat_certificate = response_hash[:envelope][:body][:sign_stamp_response][:sign_stamp_result][:no_certificado_sat]
  incidents_hash = response_hash[:envelope][:body][:sign_stamp_response][:sign_stamp_result][:incidencias]

  File.open((Rails.root.join('public', 'request', 'SOAP_Request_stamp.xml')), "w") do |file|
    file.write(request)
  end

  #Obtiene todo el contenido del SOAP Response y lo guarda en un archivo
  File.open((Rails.root.join('public', 'response', 'SOAP_new_Response_stamp.xml')), "w") do |file|
    file.write(response_hash)
  end

  #Obtiene el XML del SOAP Response y lo guarda en un archivo
  File.open((Rails.root.join('public', 'response', 'SOAP_xml_Response_stamp.xml')), "w") do |file|
    file.write(xml_response)
  end

end
