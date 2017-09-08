class Bill < ActiveRecord::Base
  # Este modelo debe contener todo lo relacionado a las facturas
  has_many :products_bills
  has_many :products, through: :products_bills
  belongs_to :order
  has_many :movements
  has_many :pending_movements
  belongs_to :business_unit
  belongs_to :store
  belongs_to :issuing_company, class_name: 'BillingAddress'
  belongs_to :receiving_company, class_name: 'BillingAddress'
  mount_uploader :pdf, BillUploader
  mount_uploader :xml, BillUploader
end
