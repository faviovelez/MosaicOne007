class ProspectsController < ApplicationController
  # Este controller es para los prospectos, todas las personas que se atienden deben ir aquí. Se liga su información con la Request (cada request debe pertenecer a un prospect).
  before_action :authenticate_user!
  before_action :set_prospect, only: [:show, :edit, :update, :destroy, :sales_view]
  before_action :set_store, only: [:index, :new, :create, :update]

  # GET /prospects
  # GET /prospects.json

  # Crea la vista de todos los prospectos que le pertenecen a una tienda, ya que una tienda puede tener varios usuarios, no queremos ligar solamente el prospecto al usuario, también a la tienda.
  def index
    user = current_user.role.name
    if user == 'store' || user == 'store-admin'
      store_prospects
    else
      business_group_prospects
    end
  end

  # GET /prospects/1
  # GET /prospects/1.json
  def show
  end

  # GET /prospects/new
  def new
    @prospect = Prospect.new
  end

  # GET /prospects/1/edit
  def edit
  end

  # POST /prospects
  # POST /prospects.json
  def create
    @prospect = Prospect.new(prospect_params)
    save_store_prospect
    respond_to do |format|
      if @prospect.save
        update_discount_rules
        format.html { redirect_to @prospect, notice: 'El prospecto fue dado de alta exitosamente.' }
        format.json { render :show, status: :created, location: @prospect }
      else
        format.html { render :new }
        format.json { render json: @prospect.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prospects/1
  # PATCH/PUT /prospects/1.json
  def update
    respond_to do |format|
      if @prospect.update(prospect_params)
        format.html { redirect_to @prospect, notice: 'El prospecto fue modificado exitosamente.' }
        format.json { render :show, status: :ok, location: @prospect }
      else
        format.html { render :edit }
        format.json { render json: @prospect.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prospects/1
  # DELETE /prospects/1.json
  def destroy
    @prospect.destroy
    respond_to do |format|
      format.html { redirect_to prospects_url, notice: 'El prospecto fue eliminado correctamente' }
      format.json { head :no_content }
    end
  end

  def business_group_prospects(bg = current_user.store.business_unit.business_group)
    @prospects = bg.prospects
  end

  def store_prospects
    @prospects = prospects = Prospect.select('prospects.id, prospects.legal_or_business_name, prospects.prospect_type, prospects.business_type, COUNT(requests.id) as request_count, COUNT(tickets.id) as ticket_count').joins('LEFT JOIN requests ON requests.prospect_id = prospects.id LEFT JOIN tickets ON tickets.prospect_id = prospects.id').where(store_id: current_user.store.id).group('prospects.id').order(:id)
  end

  def save_store_prospect(user = current_user)
    store = user.store
    @prospect.store = store
  end

  def sales_view
  end

  private

    def get_discount_rules
      @b_units = BusinessGroup.find_by_business_group_type('main').business_units
      @corporate_d_rules = DiscountRule.where(business_unit: @b_units)
      @stores_d_rules = DiscountRule.where.not(store: nil)
    end

    def update_discount_rules
      get_discount_rules
      b_g = @b_units.first.business_group
      @corporate_d_rules.each do |rule|
        unless rule.prospect_list.include?(@prospect.id.to_s)
          if rule.prospect_filter == 'todos los clientes'
            rule.prospect_list << @prospect.id.to_s if @prospect.business_group == rule.business_unit.business_group
          elsif rule.prospect_filter == 'clientes finales (no tiendas)'
            rule.prospect_list << @prospect.id.to_s if (@prospect.business_group == rule.business_unit.business_group && @prospect.store_prospect == nil)
          elsif rule.prospect_filter == 'tiendas propias y franquicias'
            rule.prospect_list << @prospect.id.to_s if (@prospect.business_group == rule.business_unit.business_group && @prospect.store_prospect != nil)
          elsif rule.prospect_filter == 'solo tiendas propias'
            type = StoreType.find_by_store_type('tienda propia')
            rule.prospect_list << @prospect.id.to_s if (@prospect.business_group == rule.business_unit.business_group && @prospect.store_type == type)
          elsif rule.prospect_filter == 'solo franquicias'
            type = StoreType.find_by_store_type('franquicia')
            rule.prospect_list << @prospect.id.to_s if (@prospect.business_group == rule.business_unit.business_group && @prospect.store_type == type)
          elsif rule.prospect_filter == 'solo distribuidores'
            type = StoreType.find_by_store_type('distribuidor')
            rule.prospect_list << @prospect.id.to_s if (@prospect.business_group == rule.business_unit.business_group && @prospect.store_type == type)
          elsif rule.prospect_filter == 'solo corporativo'
            type = StoreType.find_by_store_type('corporativo')
            rule.prospect_list << @prospect.id.to_s if (@prospect.business_group == rule.business_unit.business_group && @prospect.store_type == type)
          end
        end
        rule.save
      end
      @stores_d_rules.each do |rule|
        unless rule.prospect_list.include?(@prospect.id.to_s)
          if rule.prospect_filter == 'todos los clientes'
            rule.prospect_list << @prospect.id.to_s if @prospect.store == rule.store
          end
        end
        rule.save
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_discount_rule
      @discount_rule = DiscountRule.find(params[:id])
    end


    def prospect_params_ids
      @prospects = []
      ids = params[:discount_rule][:prospect_list]
      filter_field = params[:discount_rule][:prospect_filter]
      if ids == ['']
        if filter_field == 'todos los clientes'
          all_prospects
        elsif filter_field == 'clientes finales (no tiendas)'
          final_customers
        elsif filter_field == 'tiendas propias y franquicias'
          all_stores
        elsif filter_field == 'solo tiendas propias'
          all_own_stores
        elsif filter_field == 'solo franquicias'
          all_franchises
        elsif filter_field == 'solo distribuidores'
          all_distribuitors
        elsif filter_field == 'solo corporativo'
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

    # Use callbacks to share common setup or constraints between actions.
    def set_prospect
      @prospect = Prospect.find(params[:id])
    end

    def set_store
      @store = current_user.store
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prospect_params
      params.require(:prospect).permit(
      :store_id,
      :prospect_type,
      :contact_first_name,
      :second_last_name,
      :contact_middle_name,
      :contact_last_name,
      :contact_position,
      :direct_phone,
      :extension,
      :cell_phone,
      :business_type,
      :prospect_status,
      :discount,
      :legal_or_business_name,
      :billing_address_id,
      :delivery_address_id,
      :email,
      :business_unit_id,
      :business_group_id,
      :store_id,
      :store_code,
      :credit_days,
      :email_2,
      :email_3,
      :collection_active
    )
    end
end
