// Registro de usuario
document.getElementById('registerForm').addEventListener('submit', function(event) {
    event.preventDefault();  // Prevenir comportamiento por defecto del formulario

    let email = document.getElementById('email').value;
    let username = document.getElementById('username').value;
    let firstName = document.getElementById('firstName').value;
    let lastName = document.getElementById('lastName').value;
    let password = document.getElementById('password').value;


    // Mostrar los valores en consola para depuración
    console.log("Email:", email);
    console.log("Username:", username);
    console.log("First Name:", firstName);
    console.log("Last Name:", lastName);
    console.log("Password:", password);

    // Crear la solicitud AJAX para enviar los datos al backend
    let xhr = new XMLHttpRequest();
    xhr.open("POST", "../cgi-bin/register.pl", true); // Ruta para el backend en Perl
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    xhr.onload = function() {
        if (xhr.status === 200) {
            console.log('Registro exitoso:', xhr.responseText);
            alert('Registro completado. Ahora puedes iniciar sesión.');
            window.location.href = 'login.html'; // Redirigir al login
        } else {
            console.error('Error al registrar usuario:', xhr.status, xhr.responseText);
            alert('Error al registrar usuario');
        }
    };

    // Enviar los datos del formulario al backend
    xhr.send("email=" + encodeURIComponent(email) + "&username=" + encodeURIComponent(username) + "&password=" + encodeURIComponent(password));
});
