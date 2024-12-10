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
    xhr.open("POST", "/cgi-bin/new.pl", true);
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
function loadArticles() {
    const xhr = new XMLHttpRequest();
    xhr.open("GET", "cgi-bin/list.pl", true);
    xhr.onload = function() {
        if (xhr.status === 200) {
            const articles = JSON.parse(xhr.responseText);
            const articlesDiv = document.getElementById("articles");
            articlesDiv.innerHTML = "";
            articles.forEach(article => {
                const articleDiv = document.createElement("div");
                articleDiv.classList.add("article");
                articleDiv.innerHTML = `
                    <h3>${article.title}</h3>
                    <p>
                        <button onclick="loadSingleArticle('${article.title}')">Ver</button>
                        <button onclick="editArticle('${article.title}')">Editar</button>
                        <button onclick="deleteArticle('${article.title}')">Eliminar</button>
                    </p>
                `;
                articlesDiv.appendChild(articleDiv);
            });
        } else {
            console.error("Error la cargar artículos");
        }
    };
    xhr.onerror = function() {
        console.error("Request error...");
    };
    xhr.send();
}

// Manejo de visualización de un artículo específico
function loadSingleArticle(title) {
    const xhr = new XMLHttpRequest();
    xhr.open("GET", `/cgi-bin/view.pl?title=${encodeURIComponent(title)}`, true);
    xhr.onload = function() {
        if (xhr.status === 200) {
            const response = JSON.parse(xhr.responseText);
            if (response.content) {
                const articleContentDiv = document.createElement("div");
                articleContentDiv.id = "articleContent";
                articleContentDiv.innerHTML = response.content;
                document.body.appendChild(articleContentDiv);
            } else {
                alert('Error al cargar el artículo: ' + response.error);
            }
        } else {
            console.error("Failed to load article");
        }
    };
    xhr.onerror = function() {
        console.error("Request error...");
    };
    xhr.send();
}
