// Manejo de inicio de sesión
document.getElementById('loginForm').addEventListener('submit', function(event) {
    event.preventDefault();
    let username = document.getElementById('username').value;
    let password = document.getElementById('password').value;

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
    xhr.send("username=" + encodeURIComponent(username) + "&password=" + encodeURIComponent(password));
});

// Manejo de registro
document.getElementById('registerForm').addEventListener('submit', function(event) {
    event.preventDefault();

    let email = document.getElementById('email').value;
    let username = document.getElementById('username').value;
    let password = document.getElementById('password').value;

    console.log("Email (register):", email);
    console.log("Username (register):", username);
    console.log("Password (register):", password);

    let xhr = new XMLHttpRequest();
    xhr.open("POST", "/cgi-bin/register.pl", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    xhr.onload = function() {
        if (xhr.status === 200) {
            console.log('Registro exitoso:', xhr.responseText);
            alert('Te has registrado exitosamente. Ahora puedes iniciar sesión.');
            window.location.href = 'login.html';
        } else {
            console.error('Error al registrarse:', xhr.status, xhr.responseText);
            alert('Hubo un problema al registrar tu cuenta.');
        }
    };

    xhr.send("email=" + encodeURIComponent(email) + "&username=" + encodeURIComponent(username) + "&password=" + encodeURIComponent(password));
});

// Manejo de creación de nuevos artículos
document.getElementById('newArticleForm').addEventListener('submit', function(event) {
    event.preventDefault();

    let title = document.getElementById('title').value;
    let text = document.getElementById('text').value;

    let xhr = new XMLHttpRequest();
    xhr.open("POST", "new.pl", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    xhr.onload = function() {
        if (xhr.status === 200) {
            let response = xhr.responseText;
            console.log('Artículo creado exitosamente:', response);
            alert('Artículo creado exitosamente');
            window.location.href = 'index.html';
        } else {
            console.error('Error al crear el artículo:', xhr.status, xhr.responseText);
            alert('Hubo un problema al crear el artículo');
        }
    };

    xhr.send("title=" + encodeURIComponent(title) + "&text=" + encodeURIComponent(text));
});

// Manejo de visualización de artículos
document.addEventListener("DOMContentLoaded", function() {
    document.querySelector('a[href="cgi-bin/list.pl"]').addEventListener('click', function(e) {
        e.preventDefault();
        loadArticles();
    });
});

function loadArticles() {
    const xhr = new XMLHttpRequest();
    xhr.open("GET", "cgi-bin/list.pl", true);
    xhr.onload = function() {
        if (xhr.status === 200) {
            const parser = new DOMParser();
            const xmlDoc = parser.parseFromString(xhr.responseText, "text/xml");
            const articles = xmlDoc.getElementsByTagName("article");
            const articlesDiv = document.createElement("div");
            articlesDiv.id = "articles";
            document.body.appendChild(articlesDiv);
            articlesDiv.innerHTML = "";
            for (let i = 0; i < articles.length; i++) {
                const owner = articles[i].getElementsByTagName("owner")[0].childNodes[0].nodeValue;
                const title = articles[i].getElementsByTagName("title")[0].childNodes[0].nodeValue;
                const editLink = articles[i].getElementsByTagName("edit")[0].childNodes[0].nodeValue;
                const deleteLink = articles[i].getElementsByTagName("delete")[0].childNodes[0].nodeValue;

                const articleDiv = document.createElement("div");
                articleDiv.classList.add("article");
                articleDiv.innerHTML = `<h3>${title}</h3><p>Owner: ${owner}</p><p>Links: ${editLink} | ${deleteLink}</p>`;
                articlesDiv.appendChild(articleDiv);
            }
        } else {
            console.error("Error la cargar artuculos");
        }
    };
    xhr.onerror = function() {
        console.error("Request error...");
    };
    xhr.send();
}
