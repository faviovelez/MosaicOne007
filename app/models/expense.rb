class Expense < ActiveRecord::Base
  belongs_to :store
  belongs_to :business_unit
  belongs_to :user
  belongs_to :bill_received
  belongs_to :store
  belongs_to :payment

  after_create :save_web_id

  def save_web_id
    self.update(web_id: self.id)
  end

end
