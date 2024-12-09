#!/usr/bin/perl
use CGI;
use DBI;
use strict;
use warnings;

# Crear un objeto CGI
my $cgi = CGI->new;
# Esta línea imprime la cabecera del contenido HTML

# Verifica que el CGI está funcionando correctamente
print "<h1>Script está funcionando</h1>";

# Establecer el encabezado HTML
print $cgi->header('text/html', 'charset=UTF-8');

# Obtener datos del formulario
my $email = $cgi->param('email');
my $password = $cgi->param('password');
my $username = $cgi->param('username');

# Validar que los campos no estén vacíos
if (!$email || !$password || !$username) {
    print "<h2>Todos los campos son obligatorios.</h2>";
    print "<a href='register.html'>Intenta nuevamente</a>";
    exit;
}

# Conexión a la base de datos
my $dbh;
eval {
    $dbh = DBI->connect(
        "DBI:mysql:database=pweb1;host=db;port=3306",
        "alumno", "pweb1", 
        { RaiseError => 1, PrintError => 0 }
    );
};
if ($@) {
    print "<h2>No se pudo conectar a la base de datos. Intenta más tarde.</h2>";
    exit;
}

# Verificar si el email ya existe
my $sth = $dbh->prepare("SELECT * FROM users WHERE email = ?");
$sth->execute($email);
my $row = $sth->fetchrow_hashref;

if ($row) {
    print "<h2>Ya tienes una cuenta. <a href='login.html'>Inicia sesión</a></h2>";
} else {
    # Insertar el nuevo usuario
    $sth = $dbh->prepare("INSERT INTO users (email, password, username) VALUES (?, ?, ?)");
    $sth->execute($email, $password, $username);
    
    print "<h2>Te has registrado exitosamente. <a href='login.html'>Inicia sesión</a></h2>";
}

# Desconectar de la base de datos
$dbh->disconnect;
