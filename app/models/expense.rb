class Expense < ActiveRecord::Base
  belongs_to :store
  belongs_to :business_unit
  belongs_to :user
  belongs_to :bill_received
  belongs_to :store
  belongs_to :payment

  after_create :save_web_id_and_set_web_true

  def save_web_id_and_set_web_true
    self.update(web_id: self.id, web: true)
  end

end
