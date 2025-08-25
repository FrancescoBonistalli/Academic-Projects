function form_login(){
    //creazione del form di login/registrazione
    const sezione_home = document.getElementById("sezione-home");
    while(sezione_home.firstChild){
        sezione_home.removeChild(sezione_home.firstChild);
    }

    const div_form = document.createElement("div");
    div_form.id = "div-form";
    div_form.innerText = "(Nome e Cognome obbligatori solo in fase di registrazione)";
    sezione_home.appendChild(div_form);

    const form_credenziali = document.createElement("form");
    form_credenziali.id = "form-credenziali";
    form_credenziali.setAttribute("method", "post");

    const prova_home = document.getElementById("form-home");
    if(prova_home == null){
        form_credenziali.setAttribute("action", "login.php");
    }
    else{
        form_credenziali.setAttribute("action", "php/login.php");
    }

    div_form.appendChild(form_credenziali);


    const label_name = document.createElement("label");
    label_name.innerText = "Nome";
    form_credenziali.appendChild(label_name);

    const input_name = document.createElement("input");
    input_name.setAttribute("type", "text");
    input_name.setAttribute("placeholder", "Nome");
    input_name.setAttribute("pattern", "^[a-zA-Z]+(\\s[a-zA-Z]+)*$");
    input_name.name = "name";
    input_name.id = "nome-login";
    form_credenziali.appendChild(input_name);

    const label_surname = document.createElement("label");
    label_surname.innerText = "Cognome";
    form_credenziali.appendChild(label_surname);

    const input_surname = document.createElement("input");
    input_surname.setAttribute("type", "text");
    input_surname.setAttribute("placeholder", "Cognome");
    input_surname.setAttribute("pattern", "^[a-zA-Z]+(\\s[a-zA-Z]+)*$");
    input_surname.name = "surname";
    input_surname.id ="cognome-login";
    form_credenziali.appendChild(input_surname);
    
    const label_mail = document.createElement("label");
    label_mail.innerText = "Mail";
    form_credenziali.appendChild(label_mail);

    const input_mail = document.createElement("input");
    input_mail.setAttribute("type", "text");
    input_mail.setAttribute("placeholder", "indirizzo@mail.it");
    input_mail.setAttribute("pattern", "^(.+)@([^\\.].+)\\.([a-z]{2,})$");
    input_mail.setAttribute("required", "true");
    input_mail.name = "mail";
    input_mail.id = "mail-login";
    form_credenziali.appendChild(input_mail);

    const label_pw = document.createElement("label");
    label_pw.innerText = "Password";
    form_credenziali.appendChild(label_pw);

    const input_pw = document.createElement("input");
    input_pw.setAttribute("type", "password");
    input_pw.setAttribute("placeholder", "Password");
    input_pw.setAttribute("pattern", "^(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*])[A-Za-z\\d!@#$%^&*]{8,}$");
    input_pw.setAttribute("required", "true");
    input_pw.name = "password";
    input_pw.id = "pw-login";
    form_credenziali.appendChild(input_pw);

    const button_registra = document.createElement("button");
    button_registra.name = "registra";
    button_registra.id = "tasto-registra";
    button_registra.innerText = "Registrati";
    button_registra.setAttribute("disabled", "");
    form_credenziali.appendChild(button_registra);
    
    const button_login = document.createElement("button");
    button_login.name = "login";
    button_login.id = "tasto-login-form";
    button_login.innerText = "Login";
    button_login.setAttribute("disabled", "");
    form_credenziali.appendChild(button_login);

    Controllo_input();

}

//funzione di gestione di controllo degli input e attivazione dei bottoni
function Controllo_input(){
    const nome = document.getElementById('nome-login');
    const cognome = document.getElementById('cognome-login');
    const email = document.getElementById('mail-login');
    const password = document.getElementById('pw-login');
    const registraButton = document.getElementById('tasto-registra');
    const loginButton = document.getElementById('tasto-login-form');
    const form = document.getElementById('form-credenziali');

    function Controllo_mail_password() {
        if (email.value && password.value) {
            loginButton.disabled = false;
        } else {
            loginButton.disabled = true;
        }
    }

    function Controllo_tutto() {
        if (nome.value && cognome.value && email.value && password.value) {
            registraButton.disabled = false;
        } else {
            registraButton.disabled = true;
        }
    }

    function Controllo_singolo(elemento) {
        if (!elemento.checkValidity()) {
            elemento.style.borderColor = "red";
        } else {
            elemento.style.borderColor = "default";
        }
    }

    email.addEventListener('input', function() {
        Controllo_mail_password();
        Controllo_tutto();
    });

    password.addEventListener('input', function() {
        Controllo_mail_password();
        Controllo_tutto();
    });

    nome.addEventListener('input', function() {
        Controllo_tutto();
    });

    cognome.addEventListener('input', function() {
        Controllo_tutto();
    });

    loginButton.addEventListener('click', function() {
        Controllo_singolo(email);
        Controllo_singolo(password);
    });

    registraButton.addEventListener('click', function() {
        Controllo_singolo(nome);
        Controllo_singolo(cognome);
        Controllo_singolo(email);
        Controllo_singolo(password);
    });
}

