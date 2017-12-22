class StoresWarehouseEntry < ActiveRecord::Base
  belongs_to :product
  belongs_to :store
  belongs_to :movement
  belongs_to :store_movement

  after_create :save_web_id

  def save_web_id
    self.update(web_id: self.id)
  end

end
