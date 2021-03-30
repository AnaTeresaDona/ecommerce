class Variant < ApplicationRecord
  belongs_to :product
  belongs_to :color
  belongs_to :size

  #Validar que un producto en un color y una talla determinados solo exstan una vez. Que el stock haga la diferencia.
  validates :product_id, uniqueness: { scope:[:color_id, :size_id]}
end
