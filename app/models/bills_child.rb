class BillsChild < ActiveRecord::Base
  belongs_to :bill
  belongs_to :children, class_name: 'Bill', foreign_key: 'children_id'
end
