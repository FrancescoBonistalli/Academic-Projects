
window.onload = () =>{ Attivazione_Tasti() };


function Attivazione_Tasti(){
    if(document.getElementById("tasto-login") != null){
        const but_login = document.getElementById("tasto-login");
        but_login.addEventListener("click", form_login);
    }

}
