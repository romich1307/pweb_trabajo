document.getElementById('loginForm').addEventListener('submit', function(event) {
    event.preventDefault();
    let username = document.getElementById('username').value;
    let password = document.getElementById('password').value;

    let xhr = new XMLHttpRequest();
    xhr.open("POST", "/cgi-bin/login.pl", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.onload = function() {
        if (xhr.status === 200) {
            alert('Sesión iniciada correctamente');
            window.location.href = 'index.html';
        } else {
            alert('Error al iniciar sesión');
        }
    };
    xhr.send("username=" + username + "&password=" + password);
});

document.getElementById('registerForm').addEventListener('submit', function(event) {
    event.preventDefault();
    let username = document.getElementById('username').value;
    let password = document.getElementById('password').value;

    let xhr = new XMLHttpRequest();
    xhr.open("POST", "/cgi-bin/register.pl", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.onload = function() {
        if (xhr.status === 200) {
            alert('Registro exitoso');
            window.location.href = 'login.html';
        } else {
            alert('Error en el registro');
        }
    };
    xhr.send("username=" + username + "&password=" + password);
});
