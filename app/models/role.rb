class Role < ActiveRecord::Base
  # Para todos los roles que podrá haber en la plataforma, una vez que se creen todos, solo se podrán crear usuarios con los mismos roles y de algunos solo podrá haber 1 o 2 usuarios con ese rol.  
  has_many :users
end
