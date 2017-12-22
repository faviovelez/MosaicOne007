class Service < ActiveRecord::Base
  belongs_to :sat_key
  belongs_to :sat_unit_key
  belongs_to :store
  belongs_to :business_unit
  has_many :service_offereds
  has_many :services_tickets
  has_many :service_sales
  has_many :tickets, through: :services_tickets

  after_create :save_web_id

  def save_web_id
    self.update(web_id: self.id)
  end
  
end
