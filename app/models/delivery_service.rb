class DeliveryService < ActiveRecord::Base
  belongs_to :service_offered

  after_create :save_web_id

  def save_web_id
    self.update(web_id: self.id)
  end

end
