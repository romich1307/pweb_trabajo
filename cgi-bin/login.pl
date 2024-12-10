#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use DBI;

# Crear una instancia de CGI para obtener los parámetros del formulario
my $query = CGI->new;

# Obtener los datos del formulario
my $username = $query->param('username');
my $password = $query->param('password');

# Verificar si los campos están completos
if (!$username || !$password) {
    print $query->header('text/html');
    print "<html><body><script>alert('Por favor ingrese ambos campos: usuario y contraseña.'); window.location.href = '../login.html';</script></body></html>";
    exit;
}

# Configuración de la base de datos
my $dsn = "DBI:mysql:database=pweb1;host=db";  # Asegúrate de que el 'host' esté configurado correctamente
my $db_user = "alumno";  # Usuario de la base de datos
my $db_pass = "pweb1";   # Contraseña de la base de datos

# Conectar a la base de datos
my $dbh = DBI->connect($dsn, $db_user, $db_pass, { RaiseError => 1, AutoCommit => 1 })
    or die "No se pudo conectar a la base de datos: $DBI::errstr";

# Preparar la consulta para obtener el usuario y su contraseña
my $sth = $dbh->prepare("SELECT * FROM Users WHERE username = ? LIMIT 1");
$sth->execute($username);

# Verificar si el usuario existe
my $user = $sth->fetchrow_hashref;
if (!$user) {
    # Usuario no encontrado
    print $query->header('text/html');
    print "<html><body><script>alert('Usuario no encontrado.'); window.location.href = '../login.html';</script></body></html>";
    exit;
}

# Verificar si la contraseña es correcta (aquí deberías comparar la contraseña de manera segura)
if ($user->{password} ne $password) {
    # Contraseña incorrecta
    print $query->header('text/html');
    print "<html><body><script>alert('Contraseña incorrecta.'); window.location.href = '../login.html';</script></body></html>";
    exit;
}

# Si todo es correcto, redirigir al index
print $query->header('text/html');
print "<html><body><script>window.location.href = '../index.html';</script></body></html>";
