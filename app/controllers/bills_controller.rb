class BillsController < ApplicationController
  before_action :set_bill, only: [:show, :edit, :bill, :bill_doc, :update, :destroy]

  require 'rqrcode'

  # GET /bills
  # GET /bills.json
  def index
    @bills = Bill.all
  end

  # GET /bills/1
  # GET /bills/1.json
  def show
  end

  def select_data
  end

  def preview
    @tickets_selected = []
    tickets = params[:tickets].split('/')
    tickets.each do |ticket|
      @tickets_selected << Ticket.find(ticket)
    end
    @prospect = Prospect.find(params[:prospect])
    cfdi_use = CfdiUse.find(params[:cfdi_use])
    @cfdi_use = cfdi_use.description
    @cfdi_use_key = cfdi_use.key
    type_of_bill = TypeOfBill.find(params[:type_of_bill])
    @type_of_bill_key = type_of_bill.key + ' '
    @type_of_bill = '-' + ' ' + type_of_bill.description
    if @prospect.billing_address == nil
      redirect_to bills_select_data_path, notice: "El prospecto elegido no tiene datos de facturación registrados."
    end
  end

  def global_preview
    @tickets_selected = []
    tickets = params[:tickets].split('/')
    tickets.each do |ticket|
      @tickets_selected << Ticket.find(ticket)
    end
    @prospect = Prospect.find_by_legal_or_business_name('Público en General')
    cfdi_use = CfdiUse.find(params[:cfdi_use])
    @cfdi_use = cfdi_use.description
    @cfdi_use_key = cfdi_use.key
    type_of_bill = TypeOfBill.find(params[:type_of_bill])
    @type_of_bill_key = type_of_bill.key + ' '
    @type_of_bill = '-' + ' ' + type_of_bill.description
    if @prospect.billing_address == nil
      redirect_to bills_select_data_path, notice: "El prospecto elegido no tiene datos de facturación registrados."
    end
  end

  def rows
    @rows = []
    @tickets_selected.each do |ticket|
      ticket.store_movements.each do |sale|
        @rows << sale
      end
      ticket.service_offereds.each do |serv|
        @rows << serv
      end
    end
    @rows
  end

  def subtotal
    rows
    amounts = []
    @rows.each do |row|
      amounts << row.amount
    end
    @subtotal = amounts.inject(&:+)
  end

  def total_taxes
    rows
    amounts = []
    @rows.each do |row|
      amounts << row.taxes
    end
    @total_taxes = amounts.inject(&:+)
  end

  def total
    rows
    amounts = []
    @rows.each do |row|
      total = row.taxes + row.amount
      amounts << total
    end
    @total = amounts.inject(&:+)
  end

  def process_info
    @tickets = params[:tickets].split('/').flatten
    type_of_bill = params[:type_of_bill]
    get_prospect_from_tickets
    get_cfdi_use_from_tickets
    prospect = ''
    params[:cfdi_use].blank? ? cfdi_use = @cfdi_use : cfdi_use = params[:cfdi_use]
    if params[:cfdi_type] == 'prospect'
      params[:prospect].blank? ? prospect = @prospect : prospect = params[:prospect]
      redirect_to bills_preview_path(tickets: [@tickets], prospect: prospect, cfdi_use: cfdi_use, type_of_bill: type_of_bill), notice: "Confirme que la información es correcta."
    else
      prospect = Prospect.find_by_legal_or_business_name('Público en General')
      redirect_to bills_global_preview_path(tickets: [@tickets], prospect: prospect, cfdi_use: cfdi_use, type_of_bill: type_of_bill), notice: "Confirme que la información es correcta."
    end
  end

  def get_prospect_from_tickets
    @ticket_prospect = []
    @tickets.each do |ticket|
      @ticket_prospect << Ticket.find(ticket).prospect unless Ticket.find(ticket).prospect == nil
    end
    @prospect = @ticket_prospect.first
  end

  def get_cfdi_use_from_tickets
    @ticket_cfdi_use = []
    @tickets.each do |ticket|
      @ticket_cfdi_use << Ticket.find(ticket).cfdi_use unless Ticket.find(ticket).cfdi_use == nil
    end
    @cfdi_use = @ticket_cfdi_use.first
  end

  def qrcode
    site = 'https://verificacfdi.facturaelectronica.sat.gob.mx/default.aspx'
    id = 'F7C0E3BC-B09D-482F-881E-3F6B063DED31'
    emisor = current_user.store.business_unit.billing_address.rfc
    receptor = Prospect.find(params[:prospect]).billing_address.rfc
    total = @total.round(2).to_s
    sello = 'A1345678'
    @qr = RQRCode::QRCode.new( (site + '&id=' + id + '&re=' + emisor + '&rr=' + receptor + '&tt' + total + '&fe=' + sello),  :size => 13, :level => :h )
  end

  def global_qrcode
    site = 'https://verificacfdi.facturaelectronica.sat.gob.mx/default.aspx'
    id = 'F7C0E3BC-B09D-482F-881E-3F6B063DED31'
    emisor = current_user.store.business_unit.billing_address.rfc
    receptor = Prospect.find_by_legal_or_business_name('Público en General').billing_address.rfc
    total = @total.round(2).to_s
    sello = 'A1345678'
    @qr = RQRCode::QRCode.new( (site + '&id=' + id + '&re=' + emisor + '&rr=' + receptor + '&tt' + total + '&fe=' + sello),  :size => 13, :level => :h )
  end

  def doc
    preview
    rows
    subtotal
    total_taxes
    total
    qrcode
    filename = "fact_#{current_user.store.series}_#{current_user.store.last_bill.next}_#{Prospect.find(params[:prospect]).billing_address.rfc}"
    respond_to do |format|
      format.html
      format.pdf {
        render template: 'bills/doc',
        pdf: filename,
        page_size: 'Letter',
        layout: 'bill.html',
        show_as_html: params[:debug].present?
      }
    end
  end

  def global_doc
    preview
    rows
    subtotal
    total_taxes
    total
    global_qrcode
    filename = "fact_#{current_user.store.series}_#{current_user.store.last_bill.next}_#{Prospect.find(params[:prospect]).billing_address.rfc}"
    respond_to do |format|
      format.html
      format.pdf {
        render template: 'bills/global_doc',
        pdf: filename,
        page_size: 'Letter',
        layout: 'bill.html',
        show_as_html: params[:debug].present?
      }
    end
  end


  # GET /bills/new
  def new
    @bill = Bill.new
  end

  # GET /bills/1/edit
  def edit
  end

  # POST /bills
  # POST /bills.json
  def create
    @bill = Bill.new(bill_params)
    respond_to do |format|
      if @bill.save
        format.html { redirect_to @bill, notice: 'Bill was successfully created.' }
        format.json { render :show, status: :created, location: @bill }
      else
        format.html { render :new }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bills/1
  # PATCH/PUT /bills/1.json
  def update
    respond_to do |format|
      if @bill.update(bill_params)
        format.html { redirect_to @bill, notice: 'Bill was successfully updated.' }
        format.json { render :show, status: :ok, location: @bill }
      else
        format.html { render :edit }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1
  # DELETE /bills/1.json
  def destroy
    @bill.destroy
    respond_to do |format|
      format.html { redirect_to bills_url, notice: 'Bill was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bill
      @bill = Bill.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bill_params
      params.require(:bill).permit(
      :status,
      :order_id,
      :initial_price,
      :discount_applied,
      :automatic_discount_applied,
      :manual_discount_applied,
      :price_before_taxes,
      :type_of_bill,
      :prospect_id,
      :classification,
      :amount,
      :quantity,
      :pdf,
      :xml,
      :issuing_company_id,
      :receiving_company_id,
      :store_id,
      :sequence,
      :folio,
      :expedition_zip_id,
      :payment_condition_id,
      :payment_method_id,
      :payment_form_id,
      :tax_regime_id,
      :cfdi_use_id,
      :tax_id,
      :pac_id,
      :fiscal_folio,
      :digital_stamp,
      :sat_stamp,
      :original_chain,
      :relation_type_id,
      :child_bills_id,
      :parent_id,
      :references_field,
      :type_of_bill_id,
      :certificate,
      :currency_id,
      :fiscal_residency_id,
      :id_trib_reg_num,
      :confirmation_key,
      :exchange_rate,
      :country_id,
      :taxes_trasnferred,
      :taxes_witheld
      )
    end
end
