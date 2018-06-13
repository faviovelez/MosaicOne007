class BillReceivedsController < ApplicationController

  def new
    @bill = BillReceived.new
  end

  def edit
    @bill = BillReceived.find(params[:id])
  end

  def show
    @bill = BillReceived.find(params[:id])
  end

  def index
    @bills = BillReceived.includes(:payments).where(store_id: current_user.store.id).where.not(payment_complete: true)
  end

  def history
    @bills = BillReceived.includes(:payments).where(store_id: current_user.store.id).where(payment_complete: true)
  end

  def update
    supplier = Supplier.find(params[:supplierId])
    bill = BillReceived.find(params[:id])
    bill.update(
      folio: params[:supplier_folio],
      date_of_bill: Date.parse(params[:supplier_date_of_bill]),
      store_id: current_user.store.id,
      subtotal: params[:supplier_subtotal].to_f,
      discount: params[:supplier_discount].to_f,
      payment_complete: false,
      business_unit_id: current_user.store.business_unit.id,
      subtotal_with_discount: params[:supplier_subtotal_with_discount].to_f,
      taxes: params[:supplier_total_amount].to_f - params[:supplier_subtotal].to_f,
      taxes_rate: params[:supplier_taxes_rate].to_f,
      total_amount: params[:supplier_total_amount].to_f,
      credit_days: params[:credit_days].to_i,
      status: params[:status],
      supplier: supplier
    )
    redirect_to bill_receiveds_index_path, notice: "Se ha modificado correctamente la factura #{bill.folio} del proveedor #{bill.supplier.name}"
  end

  def create
    supplier = Supplier.find(params[:supplierId])
    bill   = BillReceived.create(
      folio: params[:supplier_folio],
      date_of_bill: Date.parse(params[:supplier_date_of_bill]),
      store_id: current_user.store.id,
      subtotal: params[:supplier_subtotal].to_f,
      discount: params[:supplier_discount].to_f,
      payment_complete: false,
      business_unit_id: current_user.store.business_unit.id,
      subtotal_with_discount: params[:supplier_subtotal_with_discount].to_f,
      taxes: params[:supplier_total_amount].to_f - params[:supplier_subtotal].to_f,
      taxes_rate: params[:supplier_taxes_rate].to_f,
      total_amount: params[:supplier_total_amount].to_f,
      credit_days: params[:credit_days].to_i,
      supplier: supplier
    )
    redirect_to bill_receiveds_index_path, notice: "Se ha creado correctamente la factura #{bill.folio} del proveedor #{bill.supplier.name}"
  end

  def attach_payment
    params[:id].each_with_index do |val, i|
      bill = BillReceived.find(val)
      unless params[:payments][i].to_f == 0
        pn = bill.payments.count + 1
        pay = Payment.create(payment_type: 'pago', total: params[:payments][i].to_f, payment_number: pn, payment_form_id: params[:payment_form].to_i, payment_date: Date.parse(params[:date]), date: Date.today, bill_received: bill)
        total_pay = bill.payments.where(payment_type: 'pago').sum(:total) - bill.payments.where(payment_type: 'devolución').sum(:total)
        total_bill = bill.total_amount
        (total_bill - total_pay < 1) ? bill.update(payment_complete: true, payment_day: Date.parse(params[:date])) : bill.update(payment_complete: false, payment_day: Date.parse(params[:date]))
        pay.payment_date > (bill.date_of_bill + bill.credit_days.days) ? bill.update(payment_on_time: false) : bill.update(payment_on_time: true)
        Document.create(document_type: 'pago', bill_received: bill, document: params[:image])
      end
    end
    redirect_to bill_receiveds_index_path, notice: 'Su pago ha sido registrado'
  end

  def get_document
    document = Document.find(params[:id])
    redirect_to document.document_url
  end

end
