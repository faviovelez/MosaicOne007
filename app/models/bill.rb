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
  belongs_to :parent, class_name: "Bill", foreign_key: 'parent_id'
  has_many :child_bills, class_name: "Bill", foreign_key: 'child_bills_id'
end
