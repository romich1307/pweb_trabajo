#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use CGI;

# Recibimos los parámetros de la solicitud
my $cgi = CGI->new;
my $username = $cgi->param('username');
my $password = $cgi->param('password');
my $email = $cgi->param('email');

# Configuración de la base de datos
my $usuario = 'alumno';
my $clave = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=172.18.0.2";
my $dbh = DBI->connect($dsn, $usuario, $clave) or die("No se pudo conectar a la base de datos!");

# Comprobamos si el nombre de usuario ya existe
my $sth = $dbh->prepare("SELECT COUNT(*) FROM Users WHERE username = ?");
$sth->execute($username);
my ($exists) = $sth->fetchrow_array;

if ($exists) {
    # Si el nombre de usuario ya existe, devolvemos un error
    print $cgi->header('application/xml');
    print "<response>\n";
    print "  <status>error</status>\n";
    print "  <message>Username already exists</message>\n";
    print "</response>\n";
} else {
    # Si no existe, insertamos el nuevo usuario
    $sth = $dbh->prepare("INSERT INTO Users (username, password, email) VALUES (?, ?, ?)");
    $sth->execute($username, $password, $email);

    # Devolvemos una respuesta de éxito
    print $cgi->header('application/xml');
    print "<response>\n";
    print "  <status>success</status>\n";
    print "  <message>User registered successfully</message>\n";
    print "</response>\n";
}

# Cerramos la conexión con la base de datos
$dbh->disconnect;
