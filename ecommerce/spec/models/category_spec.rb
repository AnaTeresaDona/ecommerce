require 'rails_helper'

RSpec.describe Category, type: :model do

  #Ver si puedo crear una categoría sin padres:
  it "is valid without a parent" do
    category = Category.create(name: "Categoria Uno")
    expect(category).to be_valid
  end

  #Ver si elimino un padre, me borra a los hijos, dependent: :destroy
  #Creo al padre y al hijo. Borro al padre. Pregunto si la categoría del hijo está nil (Por lo tanto, el test funcionó, muerto el padre, desaparece el hijo)


  it "is child destroyed if the parent is destroyed" do
    cat_parent = Category.create(name: "Categoria Uno")
    cat_child = Category.create(name: "Categoria hijo", parent: cat_parent)

    cat_parent.destroy 

    #Esperamos un nil cuando preguntamos por la categoría hijo.
    assert_nil Category.find_by_id(cat_child.id)
  end
  #pending "add some examples to (or delete) #{__FILE__}"
end
