# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version: ruby '2.6.6'

6. Según el diseño explicar al cliente cómo implementar la lista de productos del catálogo (de un ejemplo en código). Si un modelo necesita un código, deberás entregarlo al cliente como parte de la implementación:
En el modelo product se crea un método que pregunta si hay o no variantes de cada producto. Si la variante tiene un stock mayor a 0, el producto aparece en el catálogo:

def visible_on_catalog?
    #Si hay stock, devuelvo true, si no, no.

    contador = 0
    self.variants.map{|variant| contador += variant.stock}

    (contador > 0) ? false : true
    
  end

  7. Implementar o explicar las modificaciones (si las hay) al modelo OrderItem para que siga funcionando sin que afecte el resto del sistema.
  La relación deja de ser de OrderItem a Producto, porque entre ambos aparece Variant. OrderItem pasa a pertenecer al modelo Variant.

  8. Nuestro cliente, a último minuto nos solicita que nuestro sistema ocupe cupones de dos tipos: Uno para distribuir en redes sociales (1 cupón puede tener muchas personas), otro para clientes específicos (un cupon = una persona). Cada cupón puede descontar un monto de dinero o un porcentaje de la compra. Si se compra un objeto de menor precio que el crédito que da el cupón, este último queda invalidado.

  Prueba de conceptos: crearía 3 modelos:
  target_cupon en relación de 1 a uno con el modelo user y que pertenece a user. Este cupón puede tener un contador o un boolean que comience siempre en falso y  que lo invalide una vez utilizado por el cliente. Así, una vez usado el cupón de cualquiera de los dos tipos, deja de funcionar. En otras palabras, si el contador es > a 0 o el método use_target_cupon está en true, expira.
  social_cupon: como está en relación de n-n, habría que crear un modelo intermedio user_social_cupon. social_cupon tiene una relación de has_many_through user_social_cupon con user. En este caso, habría que implementar también un contador, para manejar el uso de los cupones sociales. 

  Habría que modificar también el controller del carro de compras para integrar el uso del cupón.