class Deposit < ActiveRecord::Base
  # El opuesto a Withdrawal para poner todos los depósitos a caja (fondeo con dinero)
  belongs_to :user
  belongs_to :store
  belongs_to :cash_register

  after_create :save_web_id_and_set_web_true

  def save_web_id_and_set_web_true
    self.update(web_id: self.id, web: true)
  end

end
