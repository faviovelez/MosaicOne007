class Bank < ActiveRecord::Base
  has_many :terminals
  has_many :payments

  after_create :save_web_id

  def save_web_id
    self.update(web_id: self.id)
  end

end
