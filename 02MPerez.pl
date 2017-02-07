#!/usr/bin/perl
#
# Mario Arturo Perez Rangel
# Tarea 2 (o Practica 1)
#
=head1 Buscador

Busca en un archivo URLs, nombres de dominio, direcciones de correo electronico y direcciones ip.

Cuando termina el analisis, guarda un histograma de los datos analizados en el archivo B<datos-procesados.txt>.
 
=cut Buscador

use warnings;
use strict;

my $linea;         # Variable para manipular las lineas del archivo.
my $url   = '';    # Manejar una URL
my $total = 0;     # Para entregar los resultados finales.
my %ips   = ();    # Manejar contadores para cada ip encontrada.
my %urls  = ();    # Manejar contadores para cada url encontrada.
my %dominios = (); # Manejar contadores para cada dominio encontrado.
my %correos = ();  # Manejar contadores para cada correo encontrado.

# Para determinar donde termina un nombre de dominio se usa una tabla
# con los topes de dominio definidos cuando se definio el servicio de DNS.
# Tambien se usan los codigos de pais (a dos letras) segun ISO 3166.
my %tld = (".com" => 1, ".org" => 1, ".net" => 1, ".int" => 1, ".edu" => 1,
    ".gov" => 1, ".mil" => 1, ".info" => 1, ".localdomain" => 1,
    ".biz" => 1, "arpa" => 1,
    ".af" => 1, ".ax" => 1, ".al" => 1, ".dz" => 1, ".as" => 1, ".ad" => 1,
    ".ao" => 1, ".ai" => 1, ".aq" => 1, ".ag" => 1, ".ar" => 1, ".am" => 1,
    ".aw" => 1, ".au" => 1, ".at" => 1, ".az" => 1, ".bs" => 1, ".bh" => 1,
    ".bd" => 1, ".bb" => 1, ".by" => 1, ".be" => 1, ".bz" => 1, ".bj" => 1,
    ".bm" => 1, ".bt" => 1, ".bo" => 1, ".bq" => 1, ".ba" => 1, ".bw" => 1,
    ".bv" => 1, ".br" => 1, ".io" => 1, ".bn" => 1, ".bg" => 1, ".bf" => 1,
    ".bi" => 1, ".cv" => 1, ".kh" => 1, ".cm" => 1, ".ca" => 1, ".ky" => 1,
    ".cf" => 1, ".td" => 1, ".cl" => 1, ".cn" => 1, ".cx" => 1, ".cc" => 1,
    ".co" => 1, ".km" => 1, ".cd" => 1, ".cg" => 1, ".ck" => 1, ".cr" => 1,
    ".ci" => 1, ".hr" => 1, ".cu" => 1, ".cw" => 1, ".cy" => 1, ".cz" => 1,
    ".dk" => 1, ".dj" => 1, ".dm" => 1, ".do" => 1, ".ec" => 1, ".eg" => 1,
    ".sv" => 1, ".gq" => 1, ".er" => 1, ".ee" => 1, ".et" => 1, ".fk" => 1,
    ".fo" => 1, ".fj" => 1, ".fi" => 1, ".fr" => 1, ".gf" => 1, ".pf" => 1,
    ".tf" => 1, ".ga" => 1, ".gm" => 1, ".ge" => 1, ".de" => 1, ".gh" => 1,
    ".gi" => 1, ".gr" => 1, ".gl" => 1, ".gd" => 1, ".gp" => 1, ".gu" => 1,
    ".gt" => 1, ".gg" => 1, ".gn" => 1, ".gw" => 1, ".gy" => 1, ".ht" => 1,
    ".hm" => 1, ".va" => 1, ".hn" => 1, ".hk" => 1, ".hu" => 1, ".is" => 1,
    ".in" => 1, ".id" => 1, ".ir" => 1, ".iq" => 1, ".ie" => 1, ".im" => 1,
    ".il" => 1, ".it" => 1, ".jm" => 1, ".jp" => 1, ".je" => 1, ".jo" => 1,
    ".kz" => 1, ".ke" => 1, ".ki" => 1, ".kp" => 1, ".kr" => 1, ".kw" => 1,
    ".kg" => 1, ".la" => 1, ".lv" => 1, ".lb" => 1, ".ls" => 1, ".lr" => 1,
    ".ly" => 1, ".li" => 1, ".lt" => 1, ".lu" => 1, ".mo" => 1, ".mk" => 1,
    ".mg" => 1, ".mw" => 1, ".my" => 1, ".mv" => 1, ".ml" => 1, ".mt" => 1,
    ".mh" => 1, ".mq" => 1, ".mr" => 1, ".mu" => 1, ".yt" => 1, ".mx" => 1,
    ".fm" => 1, ".md" => 1, ".mc" => 1, ".mn" => 1, ".me" => 1, ".ms" => 1,
    ".ma" => 1, ".mz" => 1, ".mm" => 1, ".na" => 1, ".nr" => 1, ".np" => 1,
    ".nl" => 1, ".nc" => 1, ".nz" => 1, ".ni" => 1, ".ne" => 1, ".ng" => 1,
    ".nu" => 1, ".nf" => 1, ".mp" => 1, ".no" => 1, ".om" => 1, ".pk" => 1,
    ".pw" => 1, ".ps" => 1, ".pa" => 1, ".pg" => 1, ".py" => 1, ".pe" => 1,
    ".ph" => 1, ".pn" => 1, ".pl" => 1, ".pt" => 1, ".pr" => 1, ".qa" => 1,
    ".re" => 1, ".ro" => 1, ".ru" => 1, ".rw" => 1, ".bl" => 1, ".sh" => 1,
    ".kn" => 1, ".lc" => 1, ".mf" => 1, ".pm" => 1, ".vc" => 1, ".ws" => 1,
    ".sm" => 1, ".st" => 1, ".sa" => 1, ".sn" => 1, ".rs" => 1, ".sc" => 1,
    ".sl" => 1, ".sg" => 1, ".sx" => 1, ".sk" => 1, ".si" => 1, ".sb" => 1,
    ".so" => 1, ".za" => 1, ".gs" => 1, ".ss" => 1, ".es" => 1, ".lk" => 1,
    ".sd" => 1, ".sr" => 1, ".sj" => 1, ".sz" => 1, ".se" => 1, ".ch" => 1,
    ".sy" => 1, ".tw" => 1, ".tj" => 1, ".tz" => 1, ".th" => 1, ".tl" => 1,
    ".tg" => 1, ".tk" => 1, ".to" => 1, ".tt" => 1, ".tn" => 1, ".tr" => 1,
    ".tm" => 1, ".tc" => 1, ".tv" => 1, ".ug" => 1, ".ua" => 1, ".ae" => 1,
    ".gb" => 1, ".uk" => 1, ".um" => 1, ".us" => 1, ".uy" => 1, ".uz" => 1,
    ".vu" => 1, ".ve" => 1, ".vn" => 1, ".vg" => 1, ".vi" => 1, ".wf" => 1,
    ".eh" => 1, ".ye" => 1, ".zm" => 1, ".zw" => 1
    );

# En perl ARGV[0] es el primer argumento en linea de comandos.
# Contrario a otros lenguajes no se trata del nombre del programa, este
# se obtiene con la variable $0.
if ($#ARGV != 0) {
    print "Uso: perl ", $0, " <archivo de datos>\n";
    exit (1);
}

# Solo aceptamos nombres de archivo conformados por caracteres de uso comun.
if (! ($ARGV[0] =~ m|[\w\d./-_]+|)) {
    print $ARGV[0], " no parece ser un nombre valido para un archivo.\n";
    exit(1);
}

open DATOS, "<", $ARGV[0]
    or die "No es posible analizar el archivo: $!.";

=pod Comienza el proceso de cada linea del archivo de datos.
=cut
while ($linea = <DATOS>) {
    chomp $linea;

=head2 Direcciones IP

Una direccion ip es un grupo de cuatro numeros enteros positivos separados por el caracter '.', como se maneja en la seccion 3.2.2 del RFC 3986 "Uniform Resource Identifier (URI): Generic Syntax". 

Cada numero esta en el rango 0-255.
=cut Direcciones IP

    # La linea tiene una direccion ip. Perl maneja \b como frontera
    # de una palabra, se usa para delimitar donde empieza/termina
    # una palabra y algunos caracteres de puntuacion.
    # Se deja la linea sin alterarla para buscar los otros tipos de
    # informacion en ella.
    if ($linea =~ /\b(((1?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9]?[0-9]|2[0-4][0-9]|25[0-5]))\b/) {
	my $ip = $1;
	my $post=$';

	# En las cabeceras del correo puede venir la direccion ip
	# en formato inverso, seguido de la correcta direccion
	# encerrada entre [ y ].
	#
	if (($post =~ /reverse/) && !($post =~ /static/)){
	    if ($post =~ /\[(((1?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9]?[0-9]|2[0-4][0-9]|25[0-5]))\]/) {
		$ip = $1; # Actualizamos la direccion ip encontrada.
	    }
	}
	$ips{$ip}++ if ($ip ne '');

	# En las cabeceras del correo electronico pueden venir
	# dos direcciones ip separadas por la palabra 'by'.
	if ($post =~ /\s+by\s+\b(((1?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9]?[0-9]|2[0-4][0-9]|25[0-5]))\b/) {
	    $ips{$ip}++ if ($ip ne '');
	}
    }

=head2 URLs

Basado en el RFC 1738 "Uniform Resource Locator", una URL tiene la forma:

<escheme>:<scheme-specific-part>

En el RFC se define "escheme" como una secuencia de alfanumericos, '.', '-' y '+'. En presente programa esta acotado a caracteres alfanumericos, tomando los esquemas mas conocidos como son: ftp, file, mailto, http y https.

La parte especifica para ftp, http y https tiene la forma:

//<usuario>:<contraseana>@<host>:<puerto>/<camino>/?<query>

en ella usuario, contrasena, puerto, camino y query pueden no estar presentes; no asi host. En contraparte, cuando se trata de file el host tambien puede estar ausente.

mailto solo especifica que debe estar la direccion de correo electronico en el formato del RFC 822. La forma en este esquema es:

mailto:<direccion de correo>

=cut URLs

=pod URL de file://
=cut
    if ($linea =~ m!file://(.+)!) {
	my $schsp = $1;
	if ($schsp =~ m!((.+)"|(.+)$)!) { 
	    $url = $1;
	    $url =~ s/".*//;
	    $url = join '', 'file://', $url;
	    $urls{$url}++ if ($url ne '');
	}
    }

=pod URL de mailto:, puede haber dos referencias de mailto en una linea.
=cut
    if ($linea =~ /mailto:(.+)/) { # URL de correo
	my $schsp = $1;

	# Busca nombre de usuario y dominio
	if ($schsp =~ /([\w=._-]+)@([\w=_-]+(\.[\w_-]+)*)/) {
	    my ($usuario, $dominio) = ($1, $2);
	    my $correo = '';
	    my $post = $';

	    # Si algunos caracteres vienen codificados se convierten
	    # al caracter correspondiente. La funcion hex convierte
	    # la cadena a un numero, la funcion chr toma ese numero
	    # y lo convierte en caracter. El modificador g permite
	    # ejecutar las funciones dentro de una expresion regular.
	    $usuario =~ s/=([0-9a-fA-F]{2})/chr(hex($1))/ge;
	    $dominio =~ s/=([0-9a-fA-F]{2})/chr(hex($1))/ge;
	    $dominio =~ s/=$//;
	    $correo = join '', $usuario, '@', $dominio;
	    $url = join '', 'mailto:', $correo;

	    $urls{$url}++ if ($url ne '');
	    $correos{$correo}++ if ($correo ne '');
	    $dominios{$dominio}++ if ($dominio ne '');
	    $linea = $post;

	    if ($linea =~ /mailto:([\w=._-]+)@([\w=_-]+(\.[\w_-]+)*)/) {
		($usuario, $dominio) = ($1, $2);
		$post = $';
		$usuario =~ s/=([0-9a-fA-F]{2})/chr(hex($1))/ge;
		$dominio =~ s/=([0-9a-fA-F]{2})/chr(hex($1))/ge;
		$dominio =~ s/=$//;
		$correo = join '', $usuario, '@', $dominio;
		$url = join '', 'mailto:', $correo;

		$urls{$url}++ if ($url ne '');
		$correos{$correo}++ if ($correo ne '');
		$dominios{$dominio}++ if ($dominio ne '');
		$linea = $post;
	    }
	}
    }

=pod URL de ftp:, http: y https:, puede haber dos URLs en una linea.
=cut
    # $schsp contiene la parte a procesar del esquema de la URL.
    if ($linea =~ m!(ftp|https?)://(.+)!) {
	my ($scheme, $schsp) = ($1, $2);
	my ($pre, $post) = ($`, $');
	my $dominio='';

	if ($pre =~ /"$/) { # La URL esta encerrada entre comillas dobles.
	    $schsp =~ s/"(.*)$//;
	    $post = ($1) ? $1 : '';
	}
	if ($pre =~ /\[$/) { # La URL esta encerrada entre corchetes
	    $schsp =~ s/\](.*)$//;
	    $post = ($1) ? $1 : '';
	}
	if ($pre =~ /<$/) { # La URL esta encerrada entre '<' y '>'
	    $schsp =~ s/\s*\>(.*)$//;
	    $post = ($1) ? $1 : '';
	}
	if ($schsp =~ /\s*\<.*$/) { # Quitar tags de html hasta el fin de linea
	    $schsp =~ s/\s*\<(.*)$//;
	    $post = ($1) ? $1 : '';
	}
	if ($schsp =~ /=$/) { # El ultimo = en la linea indica el fin de la URL
	    $schsp =~ s/=$//;
	}
	if ($schsp =~ /\s+.*$/) { # Los espacios no forman parte de una URL
	    $schsp =~ s/\s+.*$//; # quitar a partir del espacio y hasta el final
	}
	# Registramos como dominio lo que viene despues de la '@'
	if ($schsp =~ m|^(\w+:?\w*@)?([\w=._-]+)(:\d+)?/?|) {
	    $dominio = $2;
	}
	$url = join '', $scheme, '://', $schsp;
	$urls{$url}++ if ($url ne '');  # Contabiliza la url.

	$dominio =~ s/=([0-9a-fA-F]{2})/chr(hex($1))/ge;
	$dominios{$dominio}++ if ($dominio ne '');  # Contabiliza el dominio

	$linea = $post;
	if ($linea =~ m!(ftp|https?)://(.+)!) {
	    ($scheme, $schsp) = ($1, $2);
	    ($pre, $post) = ($`, $');
	    $dominio='';

	    if ($pre =~ /"$/) { # La URL esta encerrada entre comillas dobles.
		$schsp =~ s/"(.*)$//;
		$post = ($1) ? $1 : '';
	    }
	    if ($pre =~ /\[$/) { # La URL esta encerrada entre corchetes
		$schsp =~ s/\](.*)$//;
		$post = ($1) ? $1 : '';
	    }
	    if ($pre =~ /<$/) { # La URL esta encerrada entre '<' y '>'
		$schsp =~ s/\s*\>(.*)$//;
		$post = ($1) ? $1 : '';
	    }
	    if ($schsp =~ /\s*\<.*$/) {   # Quitar tags de html hasta
		$schsp =~ s/\s*\<(.*)$//; # el fin de linea
		$post = ($1) ? $1 : '';
	    }
	    if ($schsp =~ /=$/) { # El ultimo = en la linea indica el
		$schsp =~ s/=$//; # fin de la URL
	    }
	    if ($schsp =~ /\s+.*$/) {
		$schsp =~ s/\s+.*$//;
	    }
	    # Registramos como dominio lo que viene despues de la '@'
	    if ($schsp =~ m|^(\w+:?\w*@)?([\w=._-]+)(:\d+)?/?|) {
		$dominio = $2;
	    }
	    $url = join '', $scheme, '://', $schsp;
	    $urls{$url}++ if ($url ne ''); # Contabiliza la URL.

	    $dominio =~ s/=([0-9a-fA-F]{2})/chr(hex($1))/ge;
	    $dominios{$dominio}++ if ($dominio ne ''); # Contabiliza el dominio
	    $linea = $post;
	}
    }

=head2 Correos

El RFC 822 establece que una direccion de correo tiene la siguiente forma:

 parte-local@dominio

donde parte-local es el nombre de usuario local compuesto por caracteres alfanumericos y el caracter '.'.

Incluimos el caracter '=' por si viene una parte codificada.
=cut Correos
    # Busca en la linea todos las direcciones de corre posibles.
    # Se toma en cuenta la parte del dominio para registrarlo.
    if ($linea =~ /\b([\w=._-]+)@([\w=_-]+(\.[\w_-]+)*)\b/) {
	my ($usuario, $dominio) = ($1, $2);
	my ($correo, $finlp) = ('', 0);
	$linea = $';
	do { # Registra todos los correos en la linea
	    $usuario =~ s/=([0-9a-fA-F]{2})/chr(hex($1))/ge;
	    $dominio =~ s/=([0-9a-fA-F]{2})/chr(hex($1))/ge;
	    $dominio =~ s/=$//;
	    $correo = join '', $usuario, '@', $dominio;

	    $correos{$correo}++ if ($correo ne ''); # contabiliza el correo
	    $dominios{$dominio}++ if ($dominio ne ''); # Contabiliza el dominio
	    if (($linea ne '') &&
		($linea =~ /([\w=._-]+)@([\w=_-]+(\.[\w_-]+)*)/)) {
		($usuario, $dominio) = ($1, $2);
		$linea = $';
	    } else {
		$finlp = 1;  # Termina de procesar la linea.
	    }
	} while ($finlp == 0); # Termina cuando la linea este vacia o
	                       # no se encuentren correos.
    }

=head2 Dominios

Un dominio consta de secuencias de caracteres alfanumericos posiblemente combinados con guiones medios o guiones bajos ('-', '_') separados por el caracter punto.
=cut Dominio
    # Busca todos los posibles dominios en la linea.
    # La parte final de la cadena hallada debe tener la forma
    # de un dominio de alto nivel, por ejemplo '.mx'
    if ($linea =~ /\b([\w_-]+)((\.[\w_-]+)+)\b/i) {
	my ($inidom, $dominio) = ($1, $2);
	my ($code, $finlp) = ('', 0);
	$linea = $';
	do {
	    # $code tendra la ultima parte del dominio
	    if ($dominio =~ /([\w_-]*\.)*([\w_-]+)$/) {
		$code = join '', '.', lc($2);
	    }
	    if ($tld{$code}) { # Es un "top level domain" valido?
		$dominio = lc (join '', $inidom, $dominio);
		$dominios{$dominio}++ if ($dominio ne '');
	    }
	    if (($linea ne '') &&
		($linea =~ /\b([\w_-]+)((\.[\w_-]+)+)\b/i)) {
		($inidom, $dominio) = ($1, $2);
		$linea = $';
	    } else {
		$finlp = 1;  # Termina de procesar la linea.
	    }
	} while ($finlp == 0); # Termina cuando la linea esta vacia
	                       # la linea no tiene un dominio.
    }
}
close DATOS; # Cerramos el archivo de datos.

=pod Comienza a guardar los resultados encontrados
=cut
open (FINAL, ">", "datos-procesados.txt")
    or die ("No es posible crear el archivo: $!");

# Total de direcciones ip encontradas.
print FINAL "Las direcciones ip encontradas son:\n";
print FINAL "TOTAL | IP\n";
for (sort keys %ips) {
    printf FINAL " %4d | %s\n",  $ips{$_}, $_;
}
$total = keys %ips;
print FINAL "Total de ips: ", $total, "\n\n\n";

# Total de URLs encontradas
print FINAL "Los URLs encontrados son:\n";
print FINAL "TOTAL | URL\n";
for (sort keys %urls) {
    printf FINAL " %4d | %s\n",  $urls{$_}, $_;
}
$total = keys %urls;
print FINAL "Total de URLs: ", $total, "\n\n\n";

# Total de correos encontrados
print FINAL "Los direcciones de correo encontradas son:\n";
print FINAL "TOTAL | CORREO\n";
for (sort keys %correos) {
    printf FINAL " %4d | %s\n",  $correos{$_}, $_;
}
$total = keys %correos;
print FINAL "Total de correos: ", $total, "\n\n\n";

# Total de dominios encontrados
print FINAL "Los dominios encontrados son:\n";
print FINAL "TOTAL | DOMINIO\n";
for (sort keys %dominios) {
    printf FINAL " %4d | %s\n",  $dominios{$_}, $_;
}
$total = keys %dominios;
print FINAL "Total de dominios: ", $total, "\n";

close (FINAL); # Cerramos los resultados.
