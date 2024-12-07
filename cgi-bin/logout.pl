#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use CGI::Session;

# Crear sesión
my $cgi = CGI->new;
my $session = CGI::Session->new();

# Cerrar sesión
$session->delete();

print $cgi->header(-location => '/index.html');  # Redirigir a la página de inicio
