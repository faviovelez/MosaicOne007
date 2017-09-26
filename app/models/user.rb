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
  # Ya que se modifique, quitaré la línea de movements
  has_many :movements
  has_many :pending_movements
  has_many :user_sales
  has_many :production_orders
  has_many :seller_users, class_name: 'Movement', foreign_key: 'seller_user_id'
  has_many :buyer_users, class_name: 'Movement', foreign_key: 'buyer_user_id'
  has_many :seller_users, class_name: 'PendingMovement', foreign_key: 'seller_user_id'
  has_many :buyer_users, class_name: 'PendingMovement', foreign_key: 'buyer_user_id'

  validates :first_name, presence: { message: 'Por favor escriba el primer nombre del usuario.'}

  validates :last_name, presence: { message: 'Por favor anote los apellidos del usuario.'}

end
