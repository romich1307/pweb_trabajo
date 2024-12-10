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

# Mensaje de depuración: Mostrar los datos recibidos
print "Content-type: text/html\n\n";  # Para mostrar en el navegador, necesario en Perl
print "<p>Datos recibidos:</p>";
print "<p>Usuario: $username</p>";
print "<p>Contraseña: $password</p>";

# Configuración de la base de datos
my $dsn = "DBI:mysql:database=pweb1;host=db";  # Asegúrate de que el 'host' esté configurado correctamente
my $db_user = "alumno";  # Usuario de la base de datos
my $db_pass = "pweb1";   # Contraseña de la base de datos

# Mensaje de depuración: Conexión a la base de datos
print "<p>Conectando a la base de datos...</p>";

# Conectar a la base de datos
my $dbh = DBI->connect($dsn, $db_user, $db_pass, { RaiseError => 1, AutoCommit => 1 });
if ($dbh) {
    print "<p>Conexión exitosa a la base de datos.</p>";
} else {
    print "<p>Error al conectar a la base de datos: $DBI::errstr</p>";
    exit;
}

# Preparar la consulta para verificar las credenciales del usuario
print "<p>Verificando usuario y contraseña en la base de datos...</p>";
my $sth = $dbh->prepare("SELECT * FROM Users WHERE username = ? AND password = ?");
$sth->execute($username, $password);

# Verificar si se encontró el usuario en la base de datos
my $row = $sth->fetchrow_hashref();
if ($row) {
    print "<p>¡Usuario encontrado! Redirigiendo a la página principal...</p>";
    # Redirigir al usuario a la página de inicio
    print $query->redirect('../index.html');
} else {
    print "<p>Usuario o contraseña incorrectos. Intenta de nuevo.</p>";
    print "<a href='../login.html'>Volver a intentar</a>";
}

# Cerrar la conexión
$sth->finish();
$dbh->disconnect();
