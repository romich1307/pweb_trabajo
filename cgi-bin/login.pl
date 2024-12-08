#!/usr/bin/perl
use CGI;
use DBI;
use Digest::SHA qw(sha256_hex);
use strict;
use warnings;

my $cgi = CGI->new;
print $cgi->header;

# Obtener los datos del formulario de login
my $username = $cgi->param('username');
my $password = $cgi->param('password');

if ($username && $password) {
    # Conectar a la base de datos
    my $dbh = DBI->connect("DBI:mysql:database=pweb1;host=172.18.0.2", "alumno", "pweb1", { RaiseError => 1, AutoCommit => 1 })
    or die "No se pudo conectar a la base de datos: $DBI::errstr";


    # Buscar el usuario en la base de datos
    my $sth = $dbh->prepare("SELECT password FROM users WHERE username = ?");
    $sth->execute($username);
    
    if (my $row = $sth->fetchrow_hashref) {
        my $stored_password = $row->{password};
        
        # Comparar las contraseñas (hasheadas)
        if ($stored_password eq sha256_hex($password)) {
            print "Content-type: application/json\n\n";
            print '{"status": "success", "message": "Login exitoso"}';
        } else {
            print "Content-type: application/json\n\n";
            print '{"status": "error", "message": "Credenciales incorrectas"}';
        }
    } else {
        print "Content-type: application/json\n\n";
        print '{"status": "error", "message": "Usuario no encontrado"}';
    }

    $sth->finish;
    $dbh->disconnect;
} else {
    print "Content-type: application/json\n\n";
    print '{"status": "error", "message": "Faltan parámetros"}';
}
