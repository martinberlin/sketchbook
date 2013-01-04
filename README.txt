With this connection the lines A_Sel and B_Sel of the multiplexor 74HC154 (U2) that controls rows 0 to 14 are connected to RXD (pin 2) and TXD (pin 3) of the microprocessor ATmega (U1).
But as this communication legs are needed to recevied serial data we take out JP3 and JP4 leaving the serial line desconected from 74HC154 (U2).
And then we bridge JP1 and JP2 connecting A_Sel and B_Sel from multiplexor 74HC154 (U2) to SDA (pin 27) and SCL (pin 28).

Here you can find code examples to send Peggy2 serial data.
GetLineIn examples are programs that react with the music
GetLineInRender was the first version and it's the fastest one.
There is a video where you can see how it works here:
http://www.youtube.com/watch?v=UL22KLhmRMA

In Spanish

Originalmente el Peggy 2 tiene colocados puentes (en realidad son resistencias de 0 ohm) en los jumper JP3 y JP4.
Con esta conexion las lineas A_Sel y B_Sel del multiplexor 74HC154 (U2) que controla las ROW 0 a 14 quedan conectadas a
RXD (pin 2) y TXD (pin 3) del micro ATmega (U1).
Pero como estas patas de comunicacion las necesitamos para recibir los datos on line.
Entonces retirando los puentes JP3 y JP4 dejamos la linea serial desconectada del multiplexor 74HC154 (U2).
Y colocando los puentes JP1 y JP2 conectamos las lineas A_Sel y B_Sel del multiplexor 74HC154 (U2) a SDA (pin 27) y SCL (pin 28).

De esta forma el Peggy queda listo para recibir datos mientras barre las ROWS al mismo tiempo. 