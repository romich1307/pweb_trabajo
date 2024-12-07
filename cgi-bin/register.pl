#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use CGI;

# Configuración de la base de datos
my $dsn = "DBI:MariaDB:database=pweb1;host=172.18.0.2";
my $usuario = "root";
my $clave = "tu_contraseña";
my $dbh = DBI->connect($dsn, $usuario, $clave, { RaiseError => 1, AutoCommit => 1 });

# Obtener datos del formulario
my $cgi = CGI->new;
my $userName = $cgi->param('userName');
my $password = $cgi->param('password');
my $firstName = $cgi->param('firstName');
my $lastName = $cgi->param('lastName');
my $email = $cgi->param('email');  # Capturar el correo electrónico

# Validar que los campos no estén vacíos (opcional, pero recomendado)
if (!$userName || !$password || !$firstName || !$lastName || !$email) {
    print $cgi->header(-type => 'text/html');
    print "<p>Error: Todos los campos son obligatorios.</p>";
    exit;
}

# Insertar nuevo usuario en la base de datos
my $sql = "INSERT INTO users (userName, password, firstName, lastName, email) VALUES (?, ?, ?, ?, ?)";
my $sth = $dbh->prepare($sql);
$sth->execute($userName, $password, $firstName, $lastName, $email);  # Incluir el correo en la inserción

# Confirmación y redirección
print $cgi->header(-location => '/index.html');  # Redirigir al inicio
