class Withdrawal < ActiveRecord::Base
  belongs_to :user
  belongs_to :store

  after_create :save_web_id_and_set_web_true

  def save_web_id_and_set_web_true
    self.update(web_id: self.id, web: true)
  end

end
