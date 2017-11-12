class Bill < ActiveRecord::Base
  # Este modelo debe contener todo lo relacionado a las facturas
  has_many :products_bills
  has_many :products, through: :products_bills
  has_many :orders
  has_many :movements
  has_many :pending_movements
  belongs_to :store
  belongs_to :issuing_company, class_name: 'BillingAddress'
  belongs_to :receiving_company, class_name: 'BillingAddress'
  mount_uploader :pdf, BillUploader
  mount_uploader :xml, BillUploader
  belongs_to :expedition_zip
  belongs_to :payment_conditions
  belongs_to :payment_method
  belongs_to :payment_form
  belongs_to :tax_regime
  belongs_to :cfdi_use
  belongs_to :tax
  belongs_to :pac
  belongs_to :relation_type
  belongs_to :type_of_bill
  has_many :service_offereds
  has_many :tickets
  has_many :payments
  has_many :children, through: :bills_child, foreign_key: 'children_id'
  has_many :bills_child
  belongs_to :parent, class_name: 'Bill', foreign_key: 'parent_id'
end
