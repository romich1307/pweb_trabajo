#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use DBI;

# Crear una instancia de CGI para obtener los parámetros del formulario
my $query = CGI->new;

# Obtener los datos del formulario
my $email = $query->param('email');
my $username = $query->param('username');
my $password = $query->param('password');

# Validación simple (si falta algún campo, se muestra un mensaje y se queda en la página de registro)
if (!$email || !$username || !$password) {
    print $query->header('text/html');
    print "<html><body><script>alert('Todos los campos son obligatorios.'); window.location.href = 'register.html';</script></body></html>";
    exit;
}

# Conexión a la base de datos
my $dsn = "DBI:mysql:database=pweb1;host=db";  # db es el nombre del contenedor
my $db_user = "alumno";
my $db_password = "pweb1";

# Establecer la conexión a la base de datos
my $dbh = DBI->connect($dsn, $db_user, $db_password, { RaiseError => 1, AutoCommit => 1 })
    or die "No se pudo conectar a la base de datos: $DBI::errstr";

# Preparar la consulta SQL para insertar los datos en la tabla 'Users'
my $sql = "INSERT INTO Users (email, username, password) VALUES (?, ?, ?)";

# Preparar la consulta
my $sth = $dbh->prepare($sql);

# Ejecutar la consulta con los datos del formulario
$sth->execute($email, $username, $password)
    or die "No se pudo insertar el usuario: $DBI::errstr";

# Cerrar la conexión a la base de datos
$sth->finish;
$dbh->disconnect;

# Si los campos son válidos, redirigir al login
print $query->header('text/html');
print "<html><body><script>window.location.href = '/login.html';</script></body></html>";
