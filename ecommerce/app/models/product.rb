class Product < ApplicationRecord
  has_and_belongs_to_many :categories

  has_many :variants

  #Crear un método para especificar si los productos son o no visibles (cada variant tiene un stock asociado. Si tienen stock, se muestran, si no, no)
  def visible_on_catalog?
    #Si hay stock, devuelvo true, si no, no.

    contador = 0
    self.variants.map{|variant| contador += variant.stock}

    (contador > 0) ? false : true
    
  end

  # has_many :order_items
  # has_many :orders, through: :order_items
end
