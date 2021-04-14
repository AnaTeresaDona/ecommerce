class Category < ApplicationRecord
  has_and_belongs_to_many :products

  #Para dferenciar category de category_id, entre padre e hijo y permitir que los hijos sean destruidos cuando se destruya a los padres:
  belongs_to :parent, class_name: 'Category', optional: true, foreign_key: :category_id
  has_many :children, class_name: 'Category', dependent: :destroy

  #crear un método que traiga a los padres
  scope :all_parents, -> { where(category_id: nil) }
  #scope :with_juice, -> { where("juice > 0") }

  #crear un método que traiga a los hijos y a los hijos de los hijos (bíblico el tema)
  def all_children  
    self.children.map do |child|
      child.all_children << child 
    end
  end
  
end
