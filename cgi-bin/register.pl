#!/usr/bin/perl
use CGI;
use DBI;
use Digest::SHA qw(sha256_hex);
use strict;
use warnings;

my $cgi = CGI->new;
print $cgi->header('text/html; charset=UTF-8');

# Obtener los parámetros enviados desde el formulario
my $username = $cgi->param('username');
my $password = $cgi->param('password');

# Verificar que los parámetros no estén vacíos
if (!$username || !$password) {
    print "Error: Faltan parámetros (usuario o contraseña).\n";
    exit;
}

# Conectar a la base de datos
my $dbh = DBI->connect("DBI:mysql:database=pweb1;host=172.18.0.2", "alumno", "pweb1", { RaiseError => 1, AutoCommit => 1 })
    or die "No se pudo conectar a la base de datos: $DBI::errstr";

# Comprobar si el nombre de usuario ya existe
my $sth_check = $dbh->prepare("SELECT * FROM users WHERE username = ?");
$sth_check->execute($username);

if ($sth_check->fetchrow_array) {
    # El nombre de usuario ya existe
    print "Error: El nombre de usuario ya está registrado.\n";
    exit;
}

# Hashear la contraseña
my $hashed_password = sha256_hex($password);

# Insertar los nuevos datos del usuario en la base de datos
my $sth_insert = $dbh->prepare("INSERT INTO users (username, password) VALUES (?, ?)");
$sth_insert->execute($username, $hashed_password);

# Responder al cliente (Éxito)
print "Registro exitoso. Ahora puede iniciar sesión.\n";

# Cerrar la conexión a la base de datos
$sth_check->finish;
$sth_insert->finish;
$dbh->disconnect;
