#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
my $name = $q->param('name');
print $q->header('text/html;charset=UTF-8');

# Conexión a la base de datos
my $usuario = 'alumno';
my $clave = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=172.18.0.2";
my $dbh = DBI->connect($dsn, $usuario, $clave) or die("No se pudo conectar a la base de datos!");

# Consultar el contenido del título
my $sth = $dbh->prepare("SELECT markdown FROM Wiki WHERE name=?");
$sth->execute($name);
my ($markdown) = $sth->fetchrow_array;

$sth->finish;
$dbh->disconnect;

# Procesar el contenido Markdown y generar el cuerpo HTML
my $cuerpo = generarCuerpo($markdown);

# Generar la página HTML
print generarPaginaHTML('Ver Página', $name, $cuerpo);

# Subrutina para generar el cuerpo del HTML a partir del contenido Markdown
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
    while ($linea =~ /(.*)(\[)(.*)(\])(.*)(\()(.*)(\))(.*)/) {
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

# Subrutina para generar el HTML completo de la página
sub generarPaginaHTML {
    my ($titulo_pagina, $name, $cuerpo) = @_;
    my $link_borrar = "<a href='delete.pl?name=$name'>X</a>";
    my $link_editar = "<a href='edit.pl?name=$name'>E</a>";
    
    my $html = <<"HTML";
<!DOCTYPE html>
<html lang="es">
<head>
    <title>$titulo_pagina</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="../css/styles.css"> 
</head>
<body>
    <h2><a href="list.pl">Retroceder</a> - $link_borrar $link_editar</h2>
    $cuerpo
</body>
</html>
HTML
    return $html;
}
