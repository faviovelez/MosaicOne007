class ModifiedField < ActiveRecord::Base
  # Probablemente borre este modelo, era para ver que campos se habían modificado.
  belongs_to :request
  belongs_to :user
end
