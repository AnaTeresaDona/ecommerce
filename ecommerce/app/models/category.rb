class Category < ApplicationRecord
  has_and_belongs_to_many :products

  #Para dferenciar category de category_id, entre padre e hijo y permitir que los hijos sean destruidos cuando se destruya a los padres:
  belongs_to :parent, class_name: 'Category', optional: true, foreign_key: :category_id
  has_many :children, class_name: 'Category', dependent: :destroy

  #crear un método que traiga a los padres
  scope :all_parents, -> { where(category_id: nil) }
  #scope :with_juice, -> { where("juice > 0") }

  #crear un método que traiga a los hijos y a los hijos de los hijos (bíblico el tema)
  #El map rutea del primer al segundo elementos. Si tengo un arreglo de cosas, map va a ir buscando uno por uno. Crea un registro más grande que el flat_map.
  # el flatMap o concatMap convierte cada uno de los elementos que busco en una estructura con el elemento del inicial. En este caso se aplica porque cada una de las categorías que recorro es una categoría.
  def all_children  
    self.children.flat_map do |child|
      child.all_children << child 
    end
  end
  
end
