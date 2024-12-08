#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
my $name = $q->param('name');
my $markdown = $q->param('markdown');

print $q->header('text/html;charset=UTF-8');

# Si se ha recibido el nombre y el contenido, guardar la nueva página en la base de datos
if ($name && $markdown) {
    my $usuario = 'alumno';
    my $clave = 'pweb1';
    my $dsn = "DBI:MariaDB:database=pweb1;host=db";
    my $dbh = DBI->connect($dsn, $usuario, $clave) or die("No se pudo conectar a la base de datos");

    my $sth = $dbh->prepare("INSERT INTO Wiki (name, markdown) VALUES (?, ?)");
    $sth->execute($name, $markdown);

    $sth->finish;
    $dbh->disconnect;
    
    print "<h1>Página creada con éxito</h1>";
    print "<a href='view.pl?name=$name'>Ver Página</a>";
    exit;
}

print <<FORM;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../css/styles.css"> <!-- Asegúrate de que la ruta sea correcta -->
    <title>Crear Nueva Página - Wikipedia</title>
</head>
<body>
    <div class="container">
        <h1>Crear Nueva Página</h1>
        <form method="POST" action="new.pl">
            <label for="name">Nombre:</label>
            <input type="text" id="name" name="name" required><br>
            <label for="markdown">Contenido:</label><br>
            <textarea id="markdown" name="markdown" rows="20" cols="60" required></textarea><br>
            <input type="submit" value="Crear Página">
        </form>
        <p><a href="index.html">Volver al inicio</a></p>
    </div>
</body>
</html>
FORM
