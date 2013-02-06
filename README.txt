##What is this
This is a progressing sketchbook folder to send serial data through USB to a [Peggy2](http://www.evilmadscientist.com/2008/peggy-version-2-0) led panel.

##How to enable peggy2 to receive serial data
A loop programm should be installed in Peggy2 and also there is a small wiring modification. All this is [explained here](http://fasani.de/2013/01/04/peggyserial/).

##Where are the examples
In this github repo you can find code examples to send Peggy2 serial data.
GetLineIn examples are programs that react with the music
GetLineInRender was the first version and it's the fastest one.
There is a video where you can see how it works here:
http://www.youtube.com/watch?v=UL22KLhmRMA

###In Spanish

Originalmente el Peggy 2 tiene colocados puentes (en realidad son resistencias de 0 ohm) en los jumper JP3 y JP4.
Con esta conexion las lineas A_Sel y B_Sel del multiplexor 74HC154 (U2) que controla las ROW 0 a 14 quedan conectadas a RXD (pin 2) y TXD (pin 3) del micro ATmega (U1).
Pero como estas patas de comunicacion las necesitamos para recibir los datos on line.
Entonces retirando los puentes JP3 y JP4 dejamos la linea serial desconectada del multiplexor 74HC154 (U2). Y colocando los puentes JP1 y JP2 conectamos las lineas A_Sel y B_Sel del multiplexor 74HC154 (U2) a SDA (pin 27) y SCL (pin 28).

De esta forma el Peggy queda listo para recibir datos mientras barre las ROWS al mismo tiempo. 
ATENCION: Leer [esta entrada](http://fasani.de/2013/01/04/modificacion-para-hacer-funcionar-en-serie-la-peggy2/) primero ya que dependiendo del modelo de Peggy2 puede ser mucho mas facil enviar datos serie.
