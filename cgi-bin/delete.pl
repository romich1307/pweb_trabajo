#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
use DBI;

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

# Preparar la consulta para eliminar el registro de la base de datos
my $sth = $dbh->prepare("DELETE FROM Wiki WHERE name = ?");
$sth->execute($name) or die "Error al ejecutar la eliminación: $DBI::errstr";

# Comprobar cuántas filas fueron afectadas por la eliminación
my $affected_rows = $sth->rows;
if ($affected_rows == 0) {
    print "<h1>Error: No se encontró una página con el nombre '$name'.</h1>";
    print "<h2><a href='list.pl'>Volver a la lista</a></h2>";
} else {
    print "<h1>Página '$name' eliminada exitosamente.</h1>";
    print "<h2><a href='list.pl'>Volver a la lista</a></h2>";
}

# Cerrar la conexión a la base de datos
$sth->finish();
$dbh->disconnect();

