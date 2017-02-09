#!/usr/bin/perl
use warnings;
use strict;
use HTML::Template;

# Mario Arturo Perez Rangel
# Tarea 3

=head1 Uso del modulo HTML::Template

Mediante el uso del modulo B<HTML::Template> se procesan las lineas del archivo /etc/passwd (una copia) para generar el archivo I<pass.html> con auxilio de un template.

Se abre el archivo de passwords y cada linea se almacena en una entrada de un arreglo. Se procesa el arreglo para obtener, de cada entrada, los campos que la conforman, se genera un hash de los campos de cada linea.

Al final se tiene un arreglo de dichos hashes, se pasa la referencia del arreglo a la funcion I<param> del modulo Template y el resultado se escribe al archivo I<pass.html>. El archivo plantilla usado se llama I<03MPerez.tmpl>.
=cut

=pod Abrir el template para usarlo con el modulo.
=cut

my $pTemplate = HTML::Template->new(filename => './03MPerez.tmpl');

=pod Procesa la copia del archivo de passwords y el resultado lo pasa a la rutina que lo procesa y genera un arreglo de hashes para la funcion "param".
=cut

$pTemplate->param(pwdlines => &procesaLineas(&leeArchivo("passwd.txt")));

=pod El resultado procesado se escribe al archivo pass.html
=cut

open (DATOS, ">", "pass.html")
    or die "No es posible guardar resultados: $!\n";
print DATOS $pTemplate->output();
close (DATOS);

=head2 Abrir archivo de passwords

La funcion leeArchivo recibe como parametro el nombre de un archivo.
Regresa la referencia a un arreglo con todas las lineas del archivo.

Abre el archivo y vacia cada linea en una entrada del arreglo.
=cut
sub leeArchivo {
    my $archivo = shift;
    my @usuarios;

    # Abrir el archivo y guardar su contenido.
    open DATOS, "<", $archivo or
	warn "No fue posible abrir el archivo: $!\n";
    @usuarios = (<DATOS>);
    close DATOS;
    return \@usuarios;  # Regresa el arreglo creado.
}

=head2 Procesa las lineas de un arreglo

Recibe un arreglo de lineas. Cada linea debe estar formada por 7 campos separados por el caracter ':'.
Regresa la referencia a un arreglo de hashes.

Separa cada linea en campos y con esos campos arma un hash. La referencia a ese hash es almacenada en una entrada de un arreglo. Al terminar la rutina regresa la referencia a ese arreglo de hashes.
=cut
sub procesaLineas {
    my $r = shift;
    my @lhashes;

    for (@$r) { # Cada entrada del arreglo es separa en campos
	if (/(.+):(.*):(.+):(.+):(.*):(.+):(.+)/) {
	    push @lhashes, { # Crea un hash anonimo y guarda su referencia.
		"user"  => $1,
		"pass"  => $2,
		"uid"   => $3,
		"gid"   => $4,
		"desc"  => $5,
		"home"  => $6,
		"shell" => $7,
	    };
	}
    }
    return \@lhashes;  # Regresa el arreglo de hashes.
}
