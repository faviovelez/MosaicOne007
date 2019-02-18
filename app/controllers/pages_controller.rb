class PagesController < ApplicationController
  before_action :authenticate_user!
  # Pantalla principal de la aplicación.
  def index
  end

  def utilerias
    @utilerias = File.read(Rails.root.join('lib', 'sat', 'utilerias.xslt'))
    respond_to do |format|
      format.xml { render  xml: @utilerias }
    end
  end

  def date_filter
    get_report_type
    get_array_type
  end

  def help
    if current_user.role.name == 'admin-desk'
      @options = [
        ["Crear usuario", "https://youtu.be/76Aq-6ssa3w"],
        ["Modificar precios y descuentos de un pedido ya elaborado", "https://youtu.be/Wlzcu2gZOWQ"],
        ["Cancelar productos de un pedido", "https://youtu.be/EaPFNLgbgKw"],
        ["Dar de alta un prospecto", "https://youtu.be/8cfVNGKQjqY"],
        ["Cancelar o borrar un pedido", "https://youtu.be/4Z4as1qTD4g"],
        ["Dar de alta un chofer", "https://youtu.be/qce_cqfU880"],
        ["Consultar pedidos especiales", "https://youtu.be/oX4Vv48eXlQ"],
        ["Crear una cotización (pedidos especiales)", "https://youtu.be/nkjOX0pss_g"],
        ["Elaborar un pedido de productos de línea", "https://youtu.be/mYghw5KRKQs"],
        ["Crear un reporte de inventario al día de hoy", "https://youtu.be/m1no1E5RDkY"],
        ["Crear un reporte de inventario que contenga costo a una fecha", "https://youtu.be/jQLcOEyNlgY"],
        ["Dar salida o baja de mercancías", "https://youtu.be/gpdkAMF666M"],
        ["Modificar una cotización (pedido especial)", "https://youtu.be/bQPTyk4RT5o"],
        ["Dar entrada de mercancía de producción", "https://youtu.be/PQZ7I2ep57Y"],
        ["Asignar un chofer a un pedido", "https://youtu.be/MMm0tX48Elg"],
        ["Saber quién entregó o preparo un pedido", "https://youtu.be/M5nigN5ZS08"],
        ["Ver un listado de todos los pedidos", "https://youtu.be/ElMb6tahLts"],
        ["Saber qué mercancía está en almacén por entregar", "https://youtu.be/Ef0DrfhcAQs"],
        ["Ver una lista de todos mis prospectos", "https://youtu.be/CCa-qE205Ow"],
        ["Ver una lista de pedidos con diferencias", "https://youtu.be/C3Mn6bnm0_w"],
        ["Ver un historial de pedidos entregados", "https://youtu.be/BnRPFmVBP9Q"],
        ["Ver un listado de los pedidos solicitados", "https://youtu.be/BYgVPB-ZpZ8"],
        ["Ver los movimientos y ventas de un periodo de tiempo", "https://youtu.be/7jbX9tFRWCU"],
        ["Entrada de mercancía de terceros", "https://youtu.be/7IiFIqhDPoM"],
        ["Reporte de movimientos totales", "https://youtu.be/-4EgqHAr7uo"],
        ["Ver un listado de los pedidos cancelados", "https://youtu.be/Oz076cj48xQ"],
        ["Generar reporte de facturación", "https://youtu.be/ODtj-L0VlTE"],
        ["Usar la herramienta de control de inventarios", "https://youtu.be/aca32IkT10M"],
        ["Ver una lista de productos de Diseños de Cartón", "https://youtu.be/2fYOszXGs6k"],
        ["Ver una lista de servicios de Diseños de Cartón", "https://youtu.be/Nmc8eyaOqMM"],
        ["Cancelar recibo electrónico de pagos", "https://youtu.be/cf_t3Kvrjuc"],
        ["Generar recibo electrónico de pagos", "https://youtu.be/NqffdqcI1m8"],
        ["Modificar o cancelar un pago registrado", "https://youtu.be/URzqzaxlTg8"],
        ["Registrar pagos a facturas", "https://youtu.be/0UrO2_Odc9Q"],
        ["Crear facturas en formulario sin pedidos", "https://youtu.be/9R8dX9XCEkY"],
        ["Ver facturas canceladas", "https://youtu.be/HqisV8XfsNI"],
        ["Crear devolución", "https://youtu.be/l3Tfob4LLw8"],
        ["Cancelar una factura", "https://youtu.be/tgCZc_RgZvA"],
        ["Generar notas de crédito", "https://youtu.be/N_HllPLk9W0"],
        ["Facturar pedido", "https://youtu.be/GUPmYE5KVeI"],
        ["Crear producto especial", "https://youtu.be/qEEhY1jnTes"],
        ["Autorizar cotización pedido especial", "https://youtu.be/lZyIPCjqwDo"],
        ["Generar reporte de saldos", "https://youtu.be/0ePcfXj57Sk"],
        ["Generar reporte de pagos", "https://youtu.be/3l_QPkh2_GU"]
      ]
    elsif current_user.role.name == 'platform-admin'
      @options = [
        ["Ingresar al administrador de plataforma", "https://youtu.be/dtyABob4Ty0"],
        ["Pasos para crear una tienda nueva", "https://youtu.be/qKN3tFgnbO4"]
      ]
    end
  end

end
