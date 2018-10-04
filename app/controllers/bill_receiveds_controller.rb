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
    bills = BillReceived.includes(:payments, :supplier).where(store_id: current_user.store.id).where.not(payment_complete: true).group("bill_receiveds.folio", "bill_receiveds.date_of_bill", "suppliers.name, bill_receiveds.subtotal_with_discount, bill_receiveds.discount, bill_receiveds.taxes, bill_receiveds.total_amount, suppliers.credit_days, bill_receiveds.id").pluck("bill_receiveds.folio", "bill_receiveds.date_of_bill", "suppliers.name, bill_receiveds.subtotal_with_discount, bill_receiveds.discount, bill_receiveds.taxes, bill_receiveds.total_amount, COALESCE(SUM(CASE WHEN payments.payment_type = 'pago' THEN payments.total WHEN payments.payment_type = 'devolución' THEN -payments.total ELSE 0 END), 0), suppliers.credit_days, 'BillReceived', bill_receiveds.id")

    real_bills = Bill.includes(:payments, :prospect, store: [business_unit: :billing_address]).where(prospect_id: current_user.store.store_prospect.id).where.not(payed: true).group("bills.folio, bills.created_at, billing_addresses.business_name, bills.subtotal, bills.discount_applied, bills.taxes, bills.total, prospects.credit_days, bills.id").pluck("bills.folio, bills.created_at, billing_addresses.business_name, bills.subtotal, bills.discount_applied, bills.taxes, bills.total, COALESCE(SUM(CASE WHEN payments.payment_type = 'pago' THEN payments.total WHEN payments.payment_type = 'devolución' THEN -payments.total ELSE 0 END), 0), prospects.credit_days, 'Bill', bills.id")

    @bills = bills + real_bills
  end

  def history
    bills = BillReceived.includes(:payments, :supplier).where(store_id: current_user.store.id).where(payment_complete: true).group("bill_receiveds.folio", "bill_receiveds.created_at", "suppliers.name, bill_receiveds.subtotal_with_discount, bill_receiveds.discount, bill_receiveds.taxes, bill_receiveds.total_amount, suppliers.credit_days, bill_receiveds.id").pluck("bill_receiveds.folio", "bill_receiveds.created_at", "suppliers.name, bill_receiveds.subtotal_with_discount, bill_receiveds.discount, bill_receiveds.taxes, bill_receiveds.total_amount, COALESCE(SUM(CASE WHEN payments.payment_type = 'pago' THEN payments.total WHEN payments.payment_type = 'devolución' THEN -payments.total ELSE 0 END), 0), suppliers.credit_days, 'BillReceived', bill_receiveds.id, bill_receiveds.status, bill_receiveds.payment_day")

    real_bills = Bill.includes(:payments, :prospect, store: [business_unit: :billing_address]).where(prospect_id: current_user.store.store_prospect.id).where(payed: true).group("bills.folio, bills.created_at, billing_addresses.business_name, bills.subtotal, bills.discount_applied, bills.taxes, bills.total, prospects.credit_days, bills.id").pluck("bills.folio, bills.created_at, billing_addresses.business_name, bills.subtotal, bills.discount_applied, bills.taxes, bills.total, COALESCE(SUM(CASE WHEN payments.payment_type = 'pago' THEN payments.total WHEN payments.payment_type = 'devolución' THEN -payments.total ELSE 0 END), 0), prospects.credit_days, 'Bill', bills.id, bills.status, 'Aquí van los pagos'")
    @bills = bills + real_bills
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
      bill = params[:type][i].constantize.find(val)
      unless params[:payments][i].to_f == 0
        pn = bill.payments.count + 1
        pay = Payment.new(payment_type: 'pago', total: params[:payments][i].to_f, payment_number: pn, payment_form_id: params[:payment_form].to_i, payment_date: Date.parse(params[:date]), date: Date.today)
        params[:type][i] == 'BillReceived' ? pay.update(bill_received: bill) : pay.update(bill: bill)
        total_pay = bill.payments.where(payment_type: 'pago').sum(:total) - bill.payments.where(payment_type: 'devolución').sum(:total)
        params[:type][i] == 'BillReceived' ? total_bill = bill.total_amount : total_bill = bill.total
        if total_bill - total_pay < 1
          params[:type][i] == 'BillReceived' ? bill.update(payment_complete: true, payment_day: Date.parse(params[:date])) : bill.update(payed: true)
        else
          params[:type][i] == 'BillReceived' ? bill.update(payment_complete: false, payment_day: Date.parse(params[:date])) : bill.update(payed: false)
        end
        if params[:type][i] == 'BillReceived'
          pay.payment_date > (bill.date_of_bill + bill.credit_days.days) ? bill.update(payment_on_time: false) : bill.update(payment_on_time: true)
          Document.create(document_type: 'pago', bill_received: bill, document: params[:image])
        else
          Document.create(document_type: 'pago', bill: bill, document: params[:image])
        end
      end
    end
    redirect_to bill_receiveds_index_path, notice: 'Su pago ha sido registrado'
  end

  def get_document
    document = Document.find(params[:id])
    redirect_to document.document_url
  end

end
