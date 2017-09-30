class DiscountRulesController < ApplicationController
  before_action :set_discount_rule, only: [:show, :edit, :update, :destroy]

  # GET /discount_rules
  # GET /discount_rules.json
  def index
    b_unit_ids = []
    user = current_user.role.name
    b_units = current_user.store.business_unit.business_group.business_units
    b_units.each do |b|
      b_unit_ids << b.id
    end
    if user == 'admin-desk'
      @discount_rules =  DiscountRule.where(business_unit: b_unit_ids)
    else
      @discount_rules = store.discount_rules
    end
  end

  # GET /discount_rules/1
  # GET /discount_rules/1.json
  def show
  end

  # GET /discount_rules/new
  def new
    @discount_rule = DiscountRule.new
    @products = Product.all
  end

  # GET /discount_rules/1/edit
  def edit
  end

  # POST /discount_rules
  # POST /discount_rules.json
  def create
    @discount_rule = DiscountRule.new(discount_rule_params)
    product_params_ids
    prospect_params_ids
    respond_to do |format|
      if @discount_rule.save
        format.html { redirect_to @discount_rule, notice: 'Se creó una nueva regla de descuento.' }
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
    product_params_ids
    prospect_params_ids
    respond_to do |format|
      if @discount_rule.update(discount_rule_params)
        format.html { redirect_to @discount_rule, notice: 'La regla de descuento fue modificada.' }
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
      format.html { redirect_to discount_rules_url, notice: 'La regla de descuento fue eliminada.' }
      format.json { head :no_content }
    end
  end

# CREO QUE ESTE MÉTODO YA NO DEBE EXISTIR
  def product_category
    Classification.all.each do |c|
      @line = c.name
      if params[:discount_rule][:product_filter] == @line
        @products = Product.where(line: @line)
      end
    end
  end

# CREO QUE ESTE MÉTODO YA NO DEBE EXISTIR
  def prospect_category
    Classification.all.each do |c|
      @line = c.name
      if params[:discount_rule][:product_filter] == @line
        @products = Product.where(line: @line)
      end
    end
  end

  private

    def product_params_ids
      @products = []
      ids = params[:discount_rule][:product_list]
      filter = params[:discount_rule][:product_filter]
      if ids = ['']
        if filter = 'todos los productos de línea'
          all_products_except_special
        elsif filter = 'seleccionar líneas de producto'
          products_by_line
        elsif filter = 'seleccionar productos por material'
          products_by_material
        end
        @products.each do |product|
          @discount_rule.product_list << product.id unless product == ''
        end
      else
        @products = params[:discount_rule][:product_list]
        @products.each do |product|
          @discount_rule.product_list << product unless product == ''
        end
      end
    end

    def prospect_params_ids
      @prospects = []
      ids = params[:discount_rule][:prospect_list]
      filter = params[:discount_rule][:prospect_filter]
      if ids = ['']
        if filter == 'todos los clientes'
          all_prospects
        elsif filter == 'clientes finales (no tiendas)'
          final_customers
        elsif filter == 'tiendas propias y franquicias'
          all_stores
        elsif filter == 'solo tiendas propias'
          all_own_stores
        elsif filter == 'solo franquicias'
          all_franchises
        elsif filter == 'solo distribuidores'
          all_distribuitors
        elsif filter == 'solo corporativo'
          corporate_only
        end
        @prospects.each do |prospect|
          @discount_rule.prospect_list << prospect.id unless prospect == ''
        end
      else
        @prospects = params[:discount_rule][:prospect_list]
        @prospects.each do |prospect|
          @discount_rule.prospect_list << prospect unless prospect == ''
        end
      end
    end

    def all_products_except_special
      user = current_user.role.name
      suppliers_id = []
      store = current_user.store
      Supplier.where(name: [
                            'Diseños de Cartón',
                            'Comercializadora de Cartón y Diseño'
                            ]).each do |supplier|
                              suppliers_id << supplier.id
                            end
      dc_products = Product.where(supplier: suppliers_id).where.not(classification: ['especial', 'de tienda'])
      if user == 'store-admin' || user == 'store'
        @products = store.products + dc_products
      else
        @products = dc_products
      end
    end

    def products_by_line
      if params[:discount_rule][:line_filter].present?
        lines = params[:discount_rule][:line_filter]
        names = []
        Classification.find(lines).each do |c|
          names << c.name
        end
        @products = Product.where(line: names)
      end
    end

    def products_by_material
      if params[:discount_rule][:material_filter].present?
        materials = params[:discount_rule][:material_filter]
        names = []
        Material.find(materials).each do |m|
          names << m.name
        end
        @products = Product.where(main_material: names)
      end
    end

    def all_prospects
      user = current_user.role.name
      store = current_user.store
      b_g = current_user.store.business_group
      if user = 'admin-desk'
        @prospects = b_g.prospects
      else
        @prospects = store.prospects
      end
    end

    def final_customers
      b_g = current_user.store.business_group
      @prospects = b_g.prospects.where(store_prospect: nil)
    end

    def all_stores
      @prospects = Prospect.where.not(store_type: nil)
    end

    def all_own_stores
      type = StoreType.find_by_store_type('tienda propia')
      @prospects = Prospect.where(store_type: type)
    end

    def all_franchises
      type = StoreType.find_by_store_type('franquicia')
      @prospects = Prospect.where(store_type: type)
    end

    def all_distribuitors
      type = StoreType.find_by_store_type('distribuidor')
      @prospects = Prospect.where(store_type: type)
    end

    def corporate_only
      type = StoreType.find_by_store_type('corporativo')
      @prospects = Prospect.where(store_type: type)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_discount_rule
      @discount_rule = DiscountRule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def discount_rule_params
      params.require(:discount_rule).permit(
      :percentage,
      :product_list,
      :prospect_list,
      :initial_date,
      :final_date,
      :user_id,
      :store_id,
      :business_unit_id,
      :rule,
      :minimum_amount,
      :minimum_quantity,
      :exclusions,
      :active,
      :product_filter,
      :line_filter,
      :material_filter,
      :prospect_filter,
      :product_gift)
    end
end
