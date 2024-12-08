#!/usr/bin/perl
use strict;
use warnings;
use DBI;

# Configuración de la base de datos
my $dsn = "dbi:mysql:database=userdb;host=db";
my $username = "root";
my $password = "example";

# Establecer conexión con la base de datos
my $dbh = DBI->connect($dsn, $username, $password, { RaiseError => 1, AutoCommit => 1 })
  or die "No se pudo conectar a la base de datos: " . DBI->errstr;

# Ejemplo de cómo crear una tabla (si no existe) para usuarios
sub crear_tabla {
    my $sql = "CREATE TABLE IF NOT EXISTS users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(255) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL
    )";

    my $sth = $dbh->prepare($sql);
    $sth->execute() or die "No se pudo crear la tabla: " . $dbh->errstr;
}

# Función para insertar un nuevo usuario
sub insertar_usuario {
    my ($username, $password) = @_;
    
    # Preparamos la consulta para insertar un nuevo usuario
    my $sql = "INSERT INTO users (username, password) VALUES (?, ?)";
    
    my $sth = $dbh->prepare($sql);
    $sth->execute($username, $password) or die "No se pudo insertar el usuario: " . $dbh->errstr;
}

# Función para buscar un usuario por nombre de usuario
sub obtener_usuario {
    my ($username) = @_;

    # Preparamos la consulta para obtener un usuario
    my $sql = "SELECT * FROM users WHERE username = ?";
    
    my $sth = $dbh->prepare($sql);
    $sth->execute($username) or die "No se pudo ejecutar la consulta: " . $dbh->errstr;
    
    my $row = $sth->fetchrow_hashref;
    return $row;
}

# Función para cerrar la conexión a la base de datos
sub cerrar_conexion {
    $dbh->disconnect();
}

# Llamar a la función para crear la tabla al iniciar el script
crear_tabla();

# Exportar las funciones que se utilizarán desde otros scripts
1;
