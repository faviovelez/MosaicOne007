class Terminal < ActiveRecord::Base
  belongs_to :bank
  belongs_to :store
  has_many :payments

  after_create :save_web_id

  after_create :update_web_true

  def update_web_true
    self.update(web: true)
  end

  def save_web_id
    self.update(web_id: self.id)
  end

end
