class DiscountRulesController < ApplicationController
  before_action :set_discount_rule, only: [:show, :edit, :update, :destroy]

  # GET /discount_rules
  # GET /discount_rules.json
  def index
    @discount_rules = DiscountRule.all
  end

  # GET /discount_rules/1
  # GET /discount_rules/1.json
  def show
  end

  # GET /discount_rules/new
  def new
    @discount_rule = DiscountRule.new
  end

  # GET /discount_rules/1/edit
  def edit
  end

  # POST /discount_rules
  # POST /discount_rules.json
  def create
    @discount_rule = DiscountRule.new(discount_rule_params)

    respond_to do |format|
      if @discount_rule.save
        format.html { redirect_to @discount_rule, notice: 'Discount rule was successfully created.' }
        format.json { render :show, status: :created, location: @discount_rule }
      else
        format.html { render :new }
        format.json { render json: @discount_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /discount_rules/1
  # PATCH/PUT /discount_rules/1.json
  def update
    respond_to do |format|
      if @discount_rule.update(discount_rule_params)
        format.html { redirect_to @discount_rule, notice: 'Discount rule was successfully updated.' }
        format.json { render :show, status: :ok, location: @discount_rule }
      else
        format.html { render :edit }
        format.json { render json: @discount_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discount_rules/1
  # DELETE /discount_rules/1.json
  def destroy
    @discount_rule.destroy
    respond_to do |format|
      format.html { redirect_to discount_rules_url, notice: 'Discount rule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_discount_rule
      @discount_rule = DiscountRule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def discount_rule_params
      params.require(:discount_rule).permit(:percentage, :product_list, :prospect_list, :product_id, :initial_date, :final_date, :user_id, :rule, :minimum_amount, :minimum_quantity, :exclusions, :active, :business_unit_id, :store_id)
    end
end
