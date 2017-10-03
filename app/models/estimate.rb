class Estimate < ActiveRecord::Base
  belongs_to :product
  belongs_to :estimate_doc
end
