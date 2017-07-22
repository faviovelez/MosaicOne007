class ProductsController < ApplicationController
  # Este controller es para crear, modificar o borrar productos en catálogo, ya sea de línea o especiales (los de Request, una vez que se autorizan).
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    if params[:request_id]
      @request = Request.find(params[:request_id])
    end
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
    @request = Request.find(params[:request_id])
  end

  # POST /products
  # POST /products.json

  # El método create lo usa 'product-admin', sin embargo este controller genera un Order que debe estar asignada al usuario que creó la Request autorizada que está dando origen a este Producto, por eso el método find_user.
  def create
    if params[:request_id]
      @request = Request.find(params[:request_id])
    end
    find_user
    @product = Product.new(product_params)
    respond_to do |format|
      if @product.save
        @request.update(status: 'código asignado')
        @inventory = Inventory.create(product: @product)
        @order = Order.create(status: 'en espera', user: finded_user, category: 'special', prospect: @request.prospect, request: @request)
        @pending_movement = PendingMovement.create(product: @product, quantity: @request.quantity, order: @order)
        format.html { redirect_to @product, notice: 'Se creó un nuevo producto y una petición de baja de productos en espera del inventario.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  # Este método también lo puede usar solamente 'product-admin'. Tanto en create como en update falta agregar que pueda subir imágenes (un modelo diferente de documents).
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def find_user
    finded_user = nil
    users = @request.users
    store_users = User.joins(:role).where("roles.name = ? OR roles.name = ?", "store", "store-admin")
    users.each do |user|
      store_users.each do |store_user|
        if user == store_user
          finded_user = user
        end
      end
    end
    finded_user
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:former_code, :unique_code, :description, :product_type, :exterior_material_colorinterior_material_color, :impression, :exterior_color_or_design, :main_material, :resistance_main_material, :inner_length, :inner_width, :inner_height, :outer_length, :outer_width, :outer_height, :design_type, :number_of_pieces, :accesories_kit, :price)
    end
end
