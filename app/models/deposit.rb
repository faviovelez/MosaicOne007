class Deposit < ActiveRecord::Base
  # El opuesto a Withdrawal para poner todos los depósitos a caja (fondeo con dinero)
  belongs_to :user
  belongs_to :store
  belongs_to :cash_register

  after_create :update_web_true

  def update_web_true
    self.update(web: true)
  end

end
