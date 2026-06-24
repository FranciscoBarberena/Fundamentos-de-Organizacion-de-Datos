1) b- ¿Qué cambios realizaría en el procedimiento del punto anterior si se sabe que cada registro
del archivo maestro puede ser actualizado por 0 o 1 registro del archivo detalle?

**Rta**: Una vez que actualizo un producto del maestro con su correspondiente registro del detalle, ese producto nunca más va a ser actualizado.
 Entonces, lo puedo mover al principio del maestro y arrancar el nuevo seek en 1 en vez de en 0. 
 De esta manera no recorro el archivo en su totalidad de nuevo. A medida que actualizo más productos, haría el seek en 2, 3, 4, etc, recorriendo 
 cada vez menos el archivo. 
 **Aclaracion**: A veces el costo de intercambiar un registro para llevarlo al principio es muy alto, ya que las opeaciones relacionadas con archivos 
 se realizan en el almacenamiento secundario, que es órdenes de magnitud más lento que la RAM.