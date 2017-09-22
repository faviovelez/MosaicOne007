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

  def qrcode
    site = 'https://verificacfdi.facturaelectronica.sat.gob.mx/default.aspx'
    id = 'F7C0E3BC-B09D-482F-881E-3F6B063DED31'
    emisor = 'AAA010101AAA'
    receptor = 'XXX010101XXA'
    total = (125.6).to_s
    sello = 'A1345678'
    @qr = RQRCode::QRCode.new( (site + '&id=' + id + '&re=' + emisor + '&rr=' + '&rr=' + total + '&fe=' + sello),  :size => 12, :level => :h )
  end

  def bill_doc
    qrcode
    filename = "fact-#{@bill.id}"
    respond_to do |format|
      format.html
      format.pdf {
        render template: 'bills/bill',
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
      params.require(:bill).permit(:status, :order_id, :initial_price, :discount_applied, :additional_discount_applied, :price_before_taxes, :type_of_bill, :prospect_id, :classification, :store_id, :amount, :quantity, :pdf, :xml)
    end
end
