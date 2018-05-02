class CashRegister < ActiveRecord::Base
  belongs_to :store
  has_many :deposits
  has_many :tickets

  after_create :save_web_id_and_set_web_true

  def save_web_id_and_set_web_true
    self.update(web_id: self.id, web: true)
  end

end
