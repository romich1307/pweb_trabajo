#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use CGI;

# Configuración de la base de datos
my $dsn = "DBI:mysql:database=tu_base_de_datos;host=localhost";
my $usuario = "root";
my $clave = "tu_contraseña";
my $dbh = DBI->connect($dsn, $usuario, $clave, { RaiseError => 1, AutoCommit => 1 });

# Obtener datos del formulario
my $cgi = CGI->new;
my $userName = $cgi->param('userName');
my $password = $cgi->param('password');
my $firstName = $cgi->param('firstName');
my $lastName = $cgi->param('lastName');

# Insertar nuevo usuario en la base de datos
my $sql = "INSERT INTO users (userName, password, firstName, lastName) VALUES (?, ?, ?, ?)";
my $sth = $dbh->prepare($sql);
$sth->execute($userName, $password, $firstName, $lastName);

print $cgi->header(-location => '/index.html');  # Redirigir al inicio
