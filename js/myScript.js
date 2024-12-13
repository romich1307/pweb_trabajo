const SERVER_URL = "http://localhost:8080";

function showLogin(){
    const mainTag = document.getElementById("main");
    var html = `
    <p>Usuario</p> 
    <input type='text' id='usuario' name='usuario' required><br>
    <p>Contraseña</p> 
    <input type='password' id='password' name='password' required><br>
    <button style = 'margin-top: 10px' onclick='doLogin()'>Iniciar Sesion</button>`;
    mainTag.innerHTML = html;

}
function doLogin(){
    const usuario = document.getElementById("usuario").value;
    const password = document.getElementById("password").value;
    //consultamos con login.pl
    // url a momento de conectar con perl
    let url = `${SERVER_URL}/cgi-bin/login.pl?usuario=${usuario}&password=${password}`;
    console.log(url);
    let xhr = new XMLHttpRequest();
    xhr.open("GET", url, true);
    xhr.send();
    xhr.onload = function () { //llamamos a loginResponse
        loginResponse(xhr.responseXML);
    };

}

function loginResponse(xml) {
    if (!xml || !xml.getElementsByTagName('user')[0]) {
        document.getElementById("usuario").value = "";
        document.getElementById("password").value = "";
        alert("Error en la respuesta del servidor");
        return;
    }

    const userTag = xml.getElementsByTagName('user')[0];
    const ownerElement = userTag.getElementsByTagName('owner')[0];
    
    if (ownerElement && ownerElement.textContent.trim()) {
        userKey = document.getElementById("usuario").value;
        let firstName = userTag.getElementsByTagName('firstName')[0].textContent;
        let lastName = userTag.getElementsByTagName('lastName')[0].textContent;
        
        userFullName = firstName + " " + lastName;
        console.log("Inicio de sesion correcto como:", userKey);
        showLoggedIn();
    } else {
        document.getElementById("usuario").value = "";
        document.getElementById("password").value = "";
        alert("Usuario o contraseña incorrectos| Cuenta invalida");
    }
}

function showLoggedIn(){
    //Mostramos la bienvenida pero ahora con el nombre de usuario y el menu de usuario logeado
    document.getElementById("userName").textContent = userFullName;
    showWelcome();
    showMenuUserLogged();
}