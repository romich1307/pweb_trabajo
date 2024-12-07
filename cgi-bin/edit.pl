#!/usr/bin/perl
use strict;
use warnings;
use CGI ":standard";
use DBI;

my $q = CGI->new;
my $name = $q->param('name');
my $markdown = $q->param('markdown');

print $q->header('text/html;charset=UTF-8');

my $usuario = 'alumno';
my $clave = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=172.18.0.2";
my $dbh = DBI->connect($dsn, $usuario, $clave) or die("No se pudo conectar a la base de datos");

if ($markdown) {
    # Guardar los cambios
    my $sth = $dbh->prepare("UPDATE Wiki SET markdown=? WHERE name=?");
    $sth->execute($markdown, $name);

    $sth->finish;
    $dbh->disconnect;

    # Página actualizada correctamente
    print <<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Página Actualizada</title>
    <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
    <div class="container">
        <h1>Página actualizada con éxito</h1>
        <a href="view.pl?name=$name">Ver Página</a>
    </div>
</body>
</html>
HTML
    exit;  # Salir después de mostrar la página actualizada
}

# Obtener el contenido actual del archivo
my $sth = $dbh->prepare("SELECT markdown FROM Wiki WHERE name=?");
$sth->execute($name);
my ($contenido_actual) = $sth->fetchrow_array;

$sth->finish;
$dbh->disconnect;

# Formulario para editar la página
print <<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Página: $name</title>
    <link rel="stylesheet" href="../css/styles.css"> 
</head>
<body>
    <div class="container">
        <h1>Editar Página: $name</h1>
        <form method="POST" action="edit.pl">
            <input type="hidden" name="name" value="$name">
            <textarea name="markdown">$contenido_actual</textarea><br>
            <input type="submit" value="Guardar Cambios">
        </form>
        <h3><a href="view.pl?name=$name">Cancelar</a></h3>
    </div>
</body>
</html>
HTML
