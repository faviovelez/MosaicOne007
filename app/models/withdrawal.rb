class Withdrawal < ActiveRecord::Base
  belongs_to :user
  belongs_to :store

  after_create :update_web_true
  
  def update_web_true
    self.update(web: true)
  end

end
