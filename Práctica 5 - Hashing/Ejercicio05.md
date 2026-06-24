# Ejercicio 5

- La densidad de empaquetamiento de un archivo se define por la siguiente fórmula:

$$ \text{Densidad de empaquetamiento} = \frac{\text{Cantidad de registros realmente almacenados}}{\text{Capacidad total de registros}} $$

- Es decir, si un archivo tiene espacio para 8000 registros, pero solo tiene ocupados 5000, tendría una densidad de empaquetamiento de 5000/8000 = 0.625 (o 62,5% pasado a porcentaje).
- Una menor densidad de empaquetamiento reduce la posibilidad de overflow, ya que la probabilidad de que el bucket asignado a una clave esté libre está relacionada directamente con la cantidad de buckets libres. Una baja densidad también implica un alto desperdicio de espacio, ya que todos esos buckets sin claves no pueden ser usados por otros archivos (fragmentación interna: se reserva un bucket, pero no se almacena ninguna clave allí).