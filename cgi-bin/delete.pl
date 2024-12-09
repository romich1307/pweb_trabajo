#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
use DBI;

# Crear el objeto CGI
my $q = CGI->new;

# Imprimir el encabezado HTML
print $q->header('text/html;charset=UTF-8');

# Obtener el parámetro 'name' desde la solicitud
my $name = param('name');
if (!$name) {
    print "<h1>Error: No se proporcionó un nombre para eliminar.</h1>";
    print "<h2><a href='list.pl'>Volver a la lista</a></h2>";
    exit;
}

# Validar el nombre para evitar inyecciones SQL o caracteres no deseados
if ($name =~ /[^a-zA-Z0-9_\-]/) {
    print "<h1>Error: El nombre contiene caracteres no válidos.</h1>";
    print "<h2><a href='list.pl'>Volver a la lista</a></h2>";
    exit;
}

# Configurar parámetros de conexión a la base de datos
my $dsn = "DBI:MariaDB:database=pweb1;host=db";  # Cambia 'db' por el nombre del servicio en Docker
my $user = 'alumno';
my $password = 'pweb1';

# Intentar establecer la conexión con la base de datos
my $dbh;
eval {
    $dbh = DBI->connect($dsn, $user, $password, { RaiseError => 1, PrintError => 0 });
};
if ($@) {
    print "<h1>Error: No se pudo conectar a la base de datos.</h1>";
    print "<h2><a href='list.pl'>Volver a la lista</a></h2>";
    exit;
}

# Preparar la consulta SQL para eliminar el registro por nombre
my $sql = "DELETE FROM tabla WHERE name = ?";  # Reemplaza 'tabla' con el nombre de tu tabla

# Preparar y ejecutar la consulta
my $sth = $dbh->prepare($sql);
$sth->execute($name) or die "Error al ejecutar la consulta: $DBI::errstr";

# Verificar si se eliminó el registro
if ($sth->rows > 0) {
    print "<h1>El registro con el nombre '$name' ha sido eliminado exitosamente.</h1>";
} else {
    print "<h1>Error: No se encontró ningún registro con ese nombre.</h1>";
}

# Enlace para volver a la lista
print "<h2><a href='list.pl'>Volver a la lista</a></h2>";

# Cerrar la conexión a la base de datos
$sth->finish();
$dbh->disconnect();
