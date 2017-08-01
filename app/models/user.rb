class User < ActiveRecord::Base
  # Para crear o modificar usuarios
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :store
  has_many :requests, through: :request_users
  has_many :request_users
  has_many :design_requests, through: :design_request_users
  has_many :design_request_users
  belongs_to :role
  has_many :prospects
  has_many :orders
  has_many :movements
  has_many :pending_movements
  has_many :user_sales
  has_many :production_orders
  @skip = false

  validates :first_name, presence: { message: 'Por favor escriba el primer nombre del usuario.'}

  validates :last_name, presence: { message: 'Por favor anote los apellidos del usuario.'}

  def skip_notifications!()
    skip_confirmation_notification!
    @skip = true
  end

  def email_changed?
    return false if @skip
    super
  end

  def encrypted_password_changed?
    return false if @skip
    super
  end

end
