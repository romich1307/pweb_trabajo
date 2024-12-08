#!/usr/bin/perl
use strict;
use warnings;
use CGI ":standard";
use DBI;

print "Content-type: text/html\n\n";
print <<HTML;
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="utf-8">
        <title>Listado de Páginas</title>
        <link rel="stylesheet" href="../css/styles.css">
    </head>
    <body>
    <h1>Páginas de la Wiki</h1>
HTML

# Conexión a la base de datos
my $usuario = 'alumno';
my $clave = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=db";
my $dbh = DBI->connect($dsn, $usuario, $clave) or die("No se pudo conectar a la base de datos!");

# Consulta para obtener los nombres de las páginas
my $sth = $dbh->prepare("SELECT name FROM Wiki");
$sth->execute();
print "<ul>\n";
while(my @row = $sth->fetchrow_array){
    print "<li>\n";
    print "<a href='view.pl?name=$row[0]'>$row[0]</a>\n";
    print "<a href='delete.pl?name=$row[0]'>Eliminar</a>\n";
    print "<a href='edit.pl?name=$row[0]'>Editar</a>\n";
    print "</li>\n";
}
print "</ul>\n";
$sth->finish;
$dbh->disconnect;

print <<HTML;
    <ul>
        <li><a href="../new.html">Crear una nueva página</a></li>
        <li><a href="../index.html">Volver al Inicio</a></li>
    </ul>
    </body>
</html>
HTML
