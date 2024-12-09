#!/usr/bin/perl
use CGI;
use DBI;

my $cgi = CGI->new;
print $cgi->header;

# Obtener los datos del formulario
my $email = $cgi->param('email');
my $password = $cgi->param('password');

# Conexión a la base de datos
my $dbh = DBI->connect(
    "DBI:mysql:database=pweb1;host=db;port=3306",
    "alumno", "pweb1", 
    { RaiseError => 1, PrintError => 0 }
) or die "No se pudo conectar a la base de datos: $DBI::errstr";

# Verificar si el email existe en la base de datos
my $sth = $dbh->prepare("SELECT * FROM users WHERE email = ?");
$sth->execute($email);
my $row = $sth->fetchrow_hashref;

if ($row) {
    # Comparar la contraseña
    if ($password eq $row->{password}) {
        print "Inicio de sesión exitoso. <a href='index.html'>Ir al inicio</a>";
    } else {
        print "Contraseña incorrecta. <a href='login.html'>Intenta de nuevo</a>";
    }
} else {
    print "El correo no está registrado. <a href='register.html'>Regístrate</a>";
}

$dbh->disconnect;
