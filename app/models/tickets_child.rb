class TicketsChild < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :children, class_name: 'Ticket', foreign_key: 'children_id'
end
