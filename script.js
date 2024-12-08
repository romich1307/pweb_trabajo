document.getElementById('loginForm').addEventListener('submit', function(event) {
    event.preventDefault();
    let username = document.getElementById('username').value;
    let password = document.getElementById('password').value;
    
    // Mostrar valores de los campos de usuario y contraseña en la consola para depuración
    console.log("Username (login):", username);
    console.log("Password (login):", password);

    let xhr = new XMLHttpRequest();
    xhr.open("POST", "/cgi-bin/login.pl", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.onload = function() {
        if (xhr.status === 200) {
            console.log('Login successful:', xhr.responseText);
            alert('Sesión iniciada correctamente');
            window.location.href = 'index.html';
        } else {
            console.error('Error al iniciar sesión:', xhr.status, xhr.responseText);
            alert('Error al iniciar sesión');
        }
    };
    xhr.send("username=" + username + "&password=" + password);
});

document.getElementById('registerForm').addEventListener('submit', function(event) {
    event.preventDefault();  // Prevenir el comportamiento por defecto del formulario

    let email = document.getElementById('email').value;
    let username = document.getElementById('username').value;
    let password = document.getElementById('password').value;

    // Mostrar valores en consola para depuración
    console.log("Email (register):", email);
    console.log("Username (register):", username);
    console.log("Password (register):", password);

    // Crear una solicitud AJAX
    let xhr = new XMLHttpRequest();
    xhr.open("POST", "/cgi-bin/register.pl", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    // Manejar la respuesta
    xhr.onload = function() {
        if (xhr.status === 200) {
            console.log('Registro exitoso:', xhr.responseText);
            alert('Te has registrado exitosamente. Ahora puedes iniciar sesión.');
            window.location.href = 'login.html';  // Redirigir a la página de login
        } else {
            console.error('Error al registrarse:', xhr.status, xhr.responseText);
            alert('Hubo un problema al registrar tu cuenta.');
        }
    };

    // Enviar los datos
    xhr.send("email=" + encodeURIComponent(email) + "&username=" + encodeURIComponent(username) + "&password=" + encodeURIComponent(password));
});

