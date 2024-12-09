#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use CGI::Session;
use DBI;

# Configuración CGI y sesión
my $cgi = CGI->new;
my $session = CGI::Session->new("driver:File", $cgi, {Directory=>'/tmp'});

<<<<<<< HEAD
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
=======
# Verificar si el usuario ha iniciado sesión
my $owner = $session->param('userName');
if (!$owner) {
    print $cgi->header('text/xml');
    print "<article></article>"; # XML vacío si no está autenticado
>>>>>>> ca075a2641b6b23bb77081cdaa90151794f2179d
    exit;
}

# Leer datos del formulario
my $title = $cgi->param('title') || '';
my $text = $cgi->param('text') || '';

# Verificar datos válidos
if (!$title || !$text) {
    print $cgi->header('text/xml');
    print "<article></article>"; # XML vacío si faltan datos
    exit;
}

# Conectar a la base de datos
my $dsn = "DBI:mysql:database=pweb1;host=localhost";
my $db_user = "alumno";
my $db_pass = "pweb1";

my $dbh = DBI->connect($dsn, $db_user, $db_pass, { RaiseError => 1, AutoCommit => 1 });

# Insertar artículo
my $sth = $dbh->prepare("INSERT INTO Articles (title, text, owner) VALUES (?, ?, ?)");
eval {
    $sth->execute($title, $text, $owner);
};
if ($@) {
    print $cgi->header('text/xml');
    print "<article></article>"; # XML vacío si falla
    exit;
}

# Respuesta exitosa
print $cgi->header('text/xml');
print "<article><title>$title</title><text>$text</text></article>";

$sth->finish;
$dbh->disconnect;