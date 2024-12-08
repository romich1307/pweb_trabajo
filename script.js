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
    event.preventDefault();
    let username = document.getElementById('username').value;
    let password = document.getElementById('password').value;

    // Mostrar valores de los campos de usuario y contraseña en la consola para depuración
    console.log("Username (register):", username);
    console.log("Password (register):", password);

    let xhr = new XMLHttpRequest();
    xhr.open("POST", "/cgi-bin/register.pl", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.onload = function() {
        if (xhr.status === 200) {
            console.log('Registration successful:', xhr.responseText);
            alert('Registro exitoso');
            window.location.href = 'index.html';
        } else {
            console.error('Error en el registro:', xhr.status, xhr.responseText);
            alert('Error en el registro');
        }
    };
    xhr.send("username=" + username + "&password=" + password);
});
