#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use CGI::Session;
use DBI;

# Crear el objeto CGI
my $cgi = CGI->new;
my $session = CGI::Session->new("driver:File", $cgi, {Directory=>'/tmp'});

# Verificar si el usuario ha iniciado sesión
my $owner = $session->param('userName');
if (!$owner) {
    print $cgi->header('text/xml');
    print "<article></article>"; # XML vacío si no está autenticado
    exit;
}

# Imprimir el encabezado XML
print $cgi->header('text/xml;charset=UTF-8');

# Obtener los parámetros 'title' desde la solicitud
my $title = $cgi->param('title');
if (!$title) {
    print "<article></article>"; # XML vacío si no se proporcionó un título
    exit;
}

# Configurar parámetros de conexión a la base de datos
my $dsn = "DBI:MariaDB:database=pweb1;host=db";
my $user = 'alumno';
my $password = 'pweb1';

# Intentar establecer la conexión con la base de datos
my $dbh;
eval {
    $dbh = DBI->connect($dsn, $user, $password, { RaiseError => 1, PrintError => 0 });
};
if ($@) {
    print "<article></article>"; # XML vacío si no se pudo conectar a la base de datos
    exit;
}

# Preparar la consulta SQL para eliminar el artículo por título y propietario
my $sql = "DELETE FROM Articles WHERE title = ? AND owner = ?";
my $sth = $dbh->prepare($sql);
$sth->execute($title, $owner) or die "Error al ejecutar la consulta: $DBI::errstr";

# Verificar si se eliminó el artículo
if ($sth->rows > 0) {
    print "<article>\n";
    print "  <title>$title</title>\n";
    print "  <owner>$owner</owner>\n";
    print "</article>\n";
} else {
    print "<article></article>"; # XML vacío si no se encontró el artículo
}

# Cerrar la conexión a la base de datos
$sth->finish();
$dbh->disconnect();
