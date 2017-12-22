class CashRegister < ActiveRecord::Base
  belongs_to :store
  has_many :deposits
  has_many :tickets

  after_create :save_web_id

  def save_web_id
    self.update(web_id: self.id)
  end
  
end
