<?php
    session_start();

    if(isset($_SESSION['login_ok'])){
        $_SESSION['login_ok'] = false;
        $_SESSION['mail'] =null;
        $_SESSION['nome'] =null;
        $_SESSION['cognome'] =null;
    }

    echo ("<script>
            alert('Logout effettuato correttamente'); 
            window.history.back();
            </script>");
    exit;
?>