# Correciones práctica de árboles

## Lecturas y escrituras
- La manera correcta de hacerlas es como están hechas a partir del punto 15. En los puntos anteriores yo hacía las lecturas por un lado y las escrituras por otro, lo que está **MAL.**

## Cantidad mínima de claves por nodo
- La fórmula es (M DIV 2) - 1. La división es entera así que se redondea para abajo. En el caso de orden 5 sería  (5 DIV 2) - 1 = 1. En los puntos 10 y 12, con orden 5, yo había redondeado para arriba y me quedó mínimo de claves = 2. Esto en su momento estaba **MAL** según la cátedra, aunque si los buscás en google a veces aparece que se hace redondeando para arriba. **RECOMIENDO CONSULTARLE BIEN A SUS PROFES.**

## Redistribución con orden 6
