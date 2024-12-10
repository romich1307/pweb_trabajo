#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use CGI::Session;
use DBI;

# Configuración CGI y sesión
my $cgi = CGI->new;
my $session = CGI::Session->new("driver:File", $cgi, {Directory=>'/tmp'});

my $owner = $session->param('userName');
if (!$owner) {
    print $cgi->redirect('login.html'); # Redirigir a login si no está autenticado
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
my $usuario = 'alumno';
my $clave = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=db";
my $dbh = DBI->connect($dsn, $usuario, $clave, { RaiseError => 1, AutoCommit => 1 }) or die("No se pudo conectar a la base de datos");

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
