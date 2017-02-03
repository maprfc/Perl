#!/usr/bin/perl

use warnings;
use strict;

=head1 Numeros primos menores a 100
=cut

=head2 Variables globales
Se define un arreglo @primos donde se guardaran los primos.
$divisor es una bandera para indicarnos si el numero analizado es divisible por un numero menor a el.
=cut
    
my @numeros=(1..100);
my @primos=();
my $n=0;
my $i=0;
my $divisible=0;

=head2 Codigo principal
Se toman los numeros del 1 al 100 y se dividen entre cada uno de los numeros menores a el. En caso de no hallar un divisor distinto al numero tratado entonces estamos hablando de un numero primo.
=cut

print "Pragmas son modulos de Perl que afectan la fase de compilacion de los programas.\n";
print "Algunos pragmas pueden afectar la fase de ejecucion de los programas.\n";
print "Pragmas son pistas para el compilar, solo funcionan cuando son llamados con las palabras reservadas \"use\" o \"no\".\n";
print "Los pragmas siempre deben ser escritos en minusculas.\n\n";

# Recorremos el arreglo.
for (@numeros) {
    for ($i=2;$i<$_;$i++) {
	if (($_%$i)==0) {# Probamos si el numero es divisible.
	    $divisible = 1;
	}
    }
    if (! $divisible) { # El numero no tiene divisores.
	$primos[$n] = $_; # Es primo y se guarda.
	$n++;
    }
    $divisible = 0; # Reiniciamos la bandera.
}

print "@primos\n";   
