# Ejercicio 3

- **Sinónimo:** dos claves de un archivo son sinónimas entre sí cuando, al aplicarles la función de hashing (con el mod incluido), resultan en el mismo "bucket" del archivo. 
- **Colisión:** una colisión sucede cuando se almacenan 2 claves sinónimas en el archivo. Esto no necesariamente causa un problema de desbordamiento, ya que es posible que entre más de una clave en un mismo bucket.
- **Desbordamiento/Overflow:** sucede cuando se inserta una clave y, además de suceder una colision, el bucket asignado ya está lleno, provocando que la nueva clave no se pueda almacenar en su "bucket nativo".

- La condición necesaria para que pueda ocurrir una colisión y no un desborde es que debe entrar más de una clave en cada bucket del archivo. Si solo entrase una clave por bucket, cualquier colisión sería también un caso de overflow, porque el bucket asignado necesariamente ya estaría lleno.