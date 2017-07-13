class User < ActiveRecord::Base
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
  belongs_to :delivery_address
end
