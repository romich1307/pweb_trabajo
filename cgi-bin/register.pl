#!/usr/bin/perl
use CGI;
use DBI;
use Digest::SHA qw(sha256_hex);
use strict;
use warnings;

my $cgi = CGI->new;
print $cgi->header;

# Verificar si los parámetros 'username' y 'password' están presentes
if ($cgi->param('username') && $cgi->param('password')) {
    my $username = $cgi->param('username');
    my $password = $cgi->param('password');
    
    # Hashear la contraseña antes de almacenarla
    my $hashed_password = sha256_hex($password);

    # Conectar a la base de datos
    my $dbh = DBI->connect("DBI:mysql:database=pweb1;host=172.18.0.2", "alumno", "pweb1", { RaiseError => 1, AutoCommit => 1 })
    or die "No se pudo conectar a la base de datos: $DBI::errstr";


    # Preparar la consulta para insertar el usuario
    my $sth = $dbh->prepare("INSERT INTO users (username, password) VALUES (?, ?)");
    
    # Ejecutar la consulta con los datos recibidos
    $sth->execute($username, $hashed_password)
        or die "Error al registrar el usuario: $sth->errstr";

    # Devolver una respuesta JSON indicando éxito
    print "Content-type: application/json\n\n";
    print '{"status": "success", "message": "Usuario registrado correctamente"}';
    
    $sth->finish;
    $dbh->disconnect;
} else {
    # Si los parámetros no están presentes, devolver un error
    print "Content-type: application/json\n\n";
    print '{"status": "error", "message": "Faltan parámetros"}';
}
