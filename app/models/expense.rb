class Expense < ActiveRecord::Base
  belongs_to :store
  belongs_to :business_unit
  belongs_to :user
  belongs_to :bill_received
  belongs_to :store
  belongs_to :payment

  after_create :save_web_id

  after_create :update_web_true

  def update_web_true
    self.update(web: true)
  end

  def save_web_id
    self.update(web_id: self.id)
  end

end
