class User < ActiveRecord::Base
  # Para crear o modificar usuarios
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :orders, through: :orders_users
  has_many :orders_users
  belongs_to :store
  has_many :requests, through: :request_users
  has_many :request_users
  has_many :design_requests, through: :design_request_users
  has_many :design_request_users
  belongs_to :role
  has_many :prospects
  has_many :orders
  has_many :user_sales
  has_many :production_orders
  has_many :movements
  has_many :pending_movements
  has_many :tickets
  has_many :estimate_docs
  has_many :delivery_attempts
  has_many :deposits
  has_many :payments

  after_create :save_web_id

  after_create :update_web_true

  validates :first_name, presence: { message: 'Por favor escriba el primer nombre del usuario.'}

  validates :last_name, presence: { message: 'Por favor anote los apellidos del usuario.'}

  def save_web_id
    self.update(web_id: self.id)
  end

  def update_web_true
    self.update(web: true)
  end

end
