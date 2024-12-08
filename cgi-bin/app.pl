use strict;
use warnings;
use CGI;
use session;

my $q = CGI->new;

# Si el usuario intenta iniciar sesión
if ($q->param('action') eq 'login') {
    my $username = $q->param('username');
    my $password = $q->param('password');
    
    if (login($username, $password)) {
        print $q->redirect('/welcome.html');
    } else {
        print $q->header, "Credenciales incorrectas";
    }
}

# Si el usuario desea cerrar sesión
if ($q->param('action') eq 'logout') {
    logout();
    print $q->redirect('/login.html');
}

# Verificar si el usuario está logueado
if (is_logged_in()) {
    print $q->header, "Bienvenido, " . $q->escapeHTML($session->param('username'));
} else {
    print $q->header, "No estás logueado";
}
