class Bill < ActiveRecord::Base
  # Este modelo debe contener todo lo relacionado a las facturas
  has_many :products_bills
  has_many :products, through: :products_bills
  has_many :orders
  has_many :movements
  has_many :pending_movements
  has_many :documents
  has_many :store_movements
  has_many :service_offereds
  has_many :tickets
  has_many :payments
  has_many :children, through: :bills_child, foreign_key: 'children_id'
  has_many :payment_bills, through: :payment_bills, foreign_key: 'payment_bill_id'
  has_many :bills_child
  has_many :rows
  belongs_to :store
  belongs_to :prospect
  belongs_to :parent, class_name: 'Bill', foreign_key: 'parent_id'
  belongs_to :pay_bill, class_name: 'Bill', foreign_key: 'pay_bill_id'
  belongs_to :issuing_company, class_name: 'BillingAddress'
  belongs_to :receiving_company, class_name: 'BillingAddress'
  belongs_to :expedition_zip
  belongs_to :payment_method
  belongs_to :payment_form
  belongs_to :currency
  belongs_to :country
  belongs_to :tax_regime
  belongs_to :cfdi_use
  belongs_to :tax
  belongs_to :pac
  belongs_to :relation_type
  belongs_to :type_of_bill
  mount_uploader :pdf, BillUploader
  mount_uploader :xml, BillUploader
  mount_uploader :cancel_receipt, BillUploader

  after_create :update_preferred_bill_option
  after_create :send_mail_prospect_email_fields, on: :create

  def send_mail_prospect_email_fields
    BillMailer.send_bill_files(self).deliver_later
  end

  def update_preferred_bill_option
    preferred = self.prospect.preferred_bill_option
    preferred.update(payment_form_id: self.payment_form_id, payment_method_id: self.payment_method_id, cfdi_use_id: self.cfdi_use_id, payment_condition: self.payment_conditions)
  end

end
