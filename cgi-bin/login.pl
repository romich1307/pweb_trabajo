#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use CGI;
use CGI::Session;

# Configuración de la base de datos
my $dsn = "DBI:mysql:database=tu_base_de_datos;host=localhost";
my $usuario = "root";
my $clave = "tu_contraseña";
my $dbh = DBI->connect($dsn, $usuario, $clave, { RaiseError => 1, AutoCommit => 1 });

# Crear sesión
my $cgi = CGI->new;
my $session = CGI::Session->new();

# Obtener datos del formulario
my $userName = $cgi->param('userName');
my $password = $cgi->param('password');

# Verificar si el usuario y la contraseña son correctos
my $sql = "SELECT * FROM users WHERE userName = ?";
my $sth = $dbh->prepare($sql);
$sth->execute($userName);
my $row = $sth->fetchrow_hashref;

if ($row && $row->{password} eq $password) {
    $session->param('userName', $userName);
    print $cgi->header(-location => 'inicio.pl');  # Redirigir al inicio
} else {
    print $cgi->header(-type => 'text/html');
    print "<p>Usuario o contraseña incorrectos</p>";
}
