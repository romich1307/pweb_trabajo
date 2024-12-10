#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use DBI;

my $cgi = CGI->new;
my $session = CGI::Session->new("driver:File", $cgi, {Directory=>'/tmp'});

my $owner = $session->param('userName');
if (!$owner) {
    print $cgi->header('application/json', '401 Unauthorized');
    print '{"error": "No autorizado"}';
    exit;
}

my $title = $cgi->param('title');
print $cgi->header('application/json;charset=UTF-8');

# Conexión a la base de datos
my $usuario = 'alumno';
my $clave = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=db";
my $dbh = DBI->connect($dsn, $usuario, $clave) or die("No se pudo conectar a la base de datos!");

# Consultar el contenido del artículo
my $sth = $dbh->prepare("SELECT markdown FROM Articles WHERE owner=? AND title=?");
$sth->execute($owner, $title);
my ($markdown) = $sth->fetchrow_array;

$sth->finish;
$dbh->disconnect;

if ($markdown) {
    my $html_content = generarCuerpo($markdown);
    print '{"content": ' . json_encode($html_content) . '}';
} else {
    print '{"error": "Artículo no encontrado"}';
}

# Subrutina para procesar Markdown y generar HTML
sub generarCuerpo {
    my $lineas = shift;
    my $texto = "";

    # Convertir el Markdown en líneas para procesarlo
    my @lineas_split = split "\n", $lineas;
    my $num_lineas = @lineas_split;

    for (my $i = 0; $i < $num_lineas; $i++) {
        my $linea_convertida = "";

        # Detectar bloques de código (Markdown: ```)
        if ($lineas_split[$i] =~ /^(```)/) {
            $i++;
            my $codigo_inicio = "<pre><code>\n";
            my $codigo_fin = "</code></pre><br>\n";
            my $codigo_texto = "";
            # Procesar hasta encontrar el cierre del bloque de código
            for ($i; !($lineas_split[$i] =~ /^(```)/) && $i < $num_lineas; $i++) {
                $codigo_texto .= "   $lineas_split[$i]\n";
            }
            $texto .= "$codigo_inicio$codigo_texto$codigo_fin";
        } else {
            $linea_convertida = procesarLinea($lineas_split[$i]);
        }
        $texto .= "$linea_convertida";
    }

    return $texto;
}

# Subrutina para procesar cada línea de Markdown
sub procesarLinea {
    my $linea = shift;

    # Descartar las líneas en blanco
    return "" if ($linea =~ /^\s*$/);

    # Convertir énfasis (_texto_)
    while ($linea =~ /(.*)(\_)(.*)(\_)(.*)/) {
        $linea = "$1<em>$3</em>$5";
    }

    # Convertir enlaces [texto](URL)
    while ($linea =~ /(.*)(

\[)(.*)(\]

)(.*)(\()(.*)(\))(.*)/) {
        $linea = "$1<a href='$7'>$3</a>$9";
    }

    # Convertir negrita y cursiva (**texto** y ***texto***)
    while ($linea =~ /(.*)(\*\*\*)(.*)(\*\*\*)(.*)/) {
        $linea = "$1<strong><em>$3</em></strong>$5";
    }

    while ($linea =~ /(.*)(\*\*)(.*)(\*\*)(.*)/) {
        $linea = "$1<strong>$3</strong>$5";
    }

    # Convertir cursiva (*texto*)
    while ($linea =~ /(.*)(\*)(.*)(\*)(.*)/) {
        $linea = "$1<em>$3</em>$5";
    }

    # Convertir tachado (~~texto~~)
    while ($linea =~ /(.*)(\~\~)(.*)(\~\~)(.*)/) {
        $linea = "$1<del>$3</del>$5";
    }

    # Convertir encabezados (# texto, ## texto, etc.)
    if ($linea =~ /^(\#)([^#\S].*)/) {
        return "<h1>$2</h1>\n";
    } elsif ($linea =~ /^(\#\#)([^#\S].*)/) {
        return "<h2>$2</h2>\n";
    } elsif ($linea =~ /^(\#\#\#)([^#\S].*)/) {
        return "<h3>$2</h3>\n";
    } elsif ($linea =~ /^(\#\#\#\#)([^#\S].*)/) {
        return "<h4>$2</h4>\n";
    } elsif ($linea =~ /^(\#\#\#\#\#)([^#\S].*)/) {
        return "<h5>$2</h5>\n";
    } elsif ($linea =~ /^(\#\#\#\#\#\#)([^\S].*)/) {
        return "<h6>$2</h6>\n";
    } else {
        return "<p>$linea</p>\n";
    }
}

sub json_encode {
    my $string = shift;
    $string =~ s/"/\\"/g;
    $string =~ s/\n/\\n/g;
    $string =~ s/\r/\\r/g;
    $string =~ s/\t/\\t/g;
    return '"' . $string . '"';
}
