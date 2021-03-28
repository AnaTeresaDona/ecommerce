class Product < ApplicationRecord
  has_and_belongs_to_many :categories

  has_many :variants

  #Crear un método para especificar si los productos son o no visibles (cada variant tiene un stock asociado. Si tienen stock, se muestran, si no, no)
  def visible_on_catalog?
    self.variants.each do |variant|
      if variant.stock > 0
        returns true
      else  
        false
      end
    end
  end

  # has_many :order_items
  # has_many :orders, through: :order_items
end
