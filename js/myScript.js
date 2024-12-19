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
/**
 * Esta función crea el formulario para el registro de nuevos usuarios
 * el fomulario se mostrará en tag div con id main.
 * La acción al presionar el bontón de Registrar será invocar a la 
 * función doCreateAccount
 * */
function showCreateAccount(){

    const mainTag = document.getElementById("main");

    var html = `
    <label>Nombres: </label> 
    <input type='text' id='Nombre' name='Nombre' required><br>
    <label>Apellidos: </label> 
    <input type='text' id='Apellido' name='Apellido' required><br>
    <p>Usuario</p> 
    <input type='text' id='usuario' name='usuario' required><br>
    <p>Contraseña</p> 
    <input type='password' id='password' name='password' required><br>
    <button style = 'margin-top: 10px' onclick='doCreateAccount()'>Crear cuenta</button>`;

    mainTag.innerHTML = html;


}

/* Esta función extraerá los datos ingresados en el formulario de
 * registro de nuevos usuarios e invocará al CGI register.pl
 * la respuesta de este CGI será procesada por loginResponse.
 */
function doCreateAccount(){
    
    // nombre y apellido pueden escribir letras separadas y no habra problema
    const Nombre = encodeURIComponent(document.getElementById("Nombre").value).replace(/%20/g,"+");
    const Apellido = encodeURIComponent(document.getElementById("Apellido").value).replace(/%20/g,"+");
    const usuario = document.getElementById("usuario").value;
    const password = document.getElementById("password").value;


    if (usuario == "" || password == "" || Nombre == "" || Apellido == "") {
        document.getElementById("Nombre").value = "";
        document.getElementById("Apellido").value = "";
        document.getElementById("usuario").value = "";
        document.getElementById("password").value = "";
    }
    else {

      let url = `${SERVER_URL}/cgi-bin/register.pl?usuario=${usuario}&password=${password}&Nombre=${Nombre}&Apellido=${Apellido}`
        console.log(url);

        let xhr = new XMLHttpRequest();

        xhr.open("GET", url, true);
        xhr.send();
        // registramos cuenta y la logeamos automaticamente
        xhr.onload = function () {
            loginResponse(xhr.responseXML);
        };

    }


}
