class StoresWarehouseEntry < ActiveRecord::Base
  belongs_to :product
  belongs_to :store
  belongs_to :movement
  belongs_to :store_movement

  after_create :save_web_id_and_set_web_true

  def save_web_id_and_set_web_true
    self.update(web_id: self.id, web: true)
  end

end
