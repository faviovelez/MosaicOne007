class TicketsChild < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :children, class_name: 'Ticket', foreign_key: 'children_id'
  belongs_to :store

  after_create :save_web_id

  def save_web_id
    self.update(web_id: self.id)
  end

end
