class StoresSupplier < ActiveRecord::Base
  belongs_to :store
  belongs_to :supplier
end
