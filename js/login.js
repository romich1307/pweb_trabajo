// Inicio de sesión (Login)
document.getElementById('loginForm').addEventListener('submit', function(event) {
    event.preventDefault(); // Evitar recarga de la página

    let username = document.getElementById('username').value;
    let password = document.getElementById('password').value;
    
    // Mostrar los valores para depuración
    console.log("Username (login):", username);
    console.log("Password (login):", password);

    // Crear la solicitud AJAX
    let xhr = new XMLHttpRequest();
    xhr.open("POST", "../cgi-bin/login.pl", true); // Ruta para el backend en Perl
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    xhr.onload = function() {
        if (xhr.status === 200) {
            console.log('Login successful:', xhr.responseText);
            alert('Sesión iniciada correctamente');
            window.location.href = '../index.html'; // Redirigir al inicio
        } else {
            console.error('Error al iniciar sesión:', xhr.status, xhr.responseText);
            alert('Error al iniciar sesión');
        }
    };

    // Enviar los datos del formulario al backend
    xhr.send("username=" + encodeURIComponent(username) + "&password=" + encodeURIComponent(password));
});
