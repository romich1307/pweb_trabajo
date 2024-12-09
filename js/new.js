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
            // Mostrar el artículo creado o cualquier mensaje de éxito
            console.log('Artículo creado exitosamente:', response);
            alert('Artículo creado exitosamente');
            window.location.href = 'index.html'; // Redirigir a la página principal o de inicio
        } else {
            console.error('Error al crear el artículo:', xhr.status, xhr.responseText);
            alert('Hubo un problema al crear el artículo');
        }
    };

    xhr.send("title=" + encodeURIComponent(title) + "&text=" + encodeURIComponent(text));
});
