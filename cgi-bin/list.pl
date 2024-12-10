#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use DBI;

# Configuración CGI y sesión
my $cgi = CGI->new;
my $session = CGI::Session->new("driver:File", $cgi, {Directory=>'/tmp'});

# Verificar si el usuario ha iniciado sesión
my $owner = $session->param('userName');
if (!$owner) {
    print $cgi->header('text/xml');
    print "<articles></articles>"; # XML vacío si no está autenticado
    exit;
}

print $cgi->header('text/xml');
print "<articles>\n";

# Conexión a la base de datos
my $usuario = 'alumno';
my $clave = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=db";
my $dbh = DBI->connect($dsn, $usuario, $clave) or die("No se pudo conectar a la base de datos!");

# Consulta para obtener los artículos del usuario
my $sth = $dbh->prepare("SELECT title FROM Articles WHERE owner = ?");
$sth->execute($owner);

while (my @row = $sth->fetchrow_array) {
    print "  <article>\n";
    print "    <owner>$owner</owner>\n";
    print "    <title>$row[0]</title>\n";
    print "    <links>\n";
    print "      <edit><a href='edit.pl?name=$row[0]'>Editar</a></edit>\n";
    print "      <delete><a href='delete.pl?name=$row[0]'>Eliminar</a></delete>\n";
    print "    </links>\n";
    print "  </article>\n";
}

print "</articles>\n";
$sth->finish;
$dbh->disconnect;
