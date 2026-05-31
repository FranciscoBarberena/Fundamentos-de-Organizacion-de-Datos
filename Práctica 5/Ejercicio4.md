# Ejercicio 4

- Para bajar la probabilidad de colisiones, se usa una mezcla de las siguientes alternativas: 
    - La funcíon de hasing debe distribuir los registros de la manera más uniforme posible.
    - Se puede asignar más buckets al archivo de los que realmente necesita. De esta manera, hay más buckets y baja la probabilidad de que se asigne el mismo a 2 registros distintos. Esto necesariamente significa reducir la densidad de empaquetamiento.
        - Tiene la desventaja de que se desperdicia espacio de disco.
    - Finalmente, la técnica principal es aumentar la cantidad de claves que entran en cada bucket. Esto en realidad no reduce la probabilidad de una colisión (porque no se relaciona con la *cantidad* de buckets), pero sí reduce la probabilidad de overflow. Es decir, aunque la probabilidad de que se le asigne el mismo bucket a 2 claves es la misma, es menor la probabilidad de que ese bucket ya esté lleno.