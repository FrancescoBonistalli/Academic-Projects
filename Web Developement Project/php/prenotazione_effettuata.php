<?php
    session_start();
?>
<!DOCTYPE html>
<html lang="it">
    <head>
        <meta charset="utf-8">
        <title>Montefoscoli Hotel</title>
        <meta name="viewport" content="width=device-width" >
        <link rel="stylesheet" href="../css/style2.css">
        <link rel="stylesheet" href="../css/style3.css">
        <link rel="stylesheet" href="../css/style6.css">
        <script src="../js/caricamento-home.js"></script>
        <script src="../js/credenziali.js"></script>
    </head>
    <body>
        <table id="tabella-home-page">
            <tr id="prima-riga-home">
                <td>
                    <img src="../img/logo-prova.png" alt="../img/riserva/logo-prova.png" id="logo">
                </td>
                <td id="scritta">
                    Hotel Montefoscoli
                </td>
                <td>
                    <?php
                        if (isset($_SESSION['login_ok']) && $_SESSION['login_ok'] == true){
                            echo "<form action=\"disconnetti.php\">
                                    <button id=\"tasto-esci\">Esci</button>
                                  </form>";                        
                        } 
                        else{
                            echo "<button id=\"tasto-login\">Login</button>";
                        }
                    ?>
                </td>
            </tr>
            <tr id="seconda-riga-home">
                <td>
                    <form action="../index.php">
                        <button id="tasto-home">
                            Home
                            <img src="../img/icons/home.png" alt="../img/icons/riserva/home.png" class="icona-bottone">
                        </button>
                    </form>
                </td>
                <td>
                    <form action="stanze.php">
                    <button id="tasto-camere">
                        Camere
                        <img src="../img/icons/double-bed.png" alt="../img/icons/riserva/double-bed.png" class="icona-bottone">
                    </button>
                    </form>   
                </td>
                <td>
                    <form action="altro.php">
                        <button id="tasto-altro">
                            Altro
                            <img src="../img/icons/more.png" alt="../img/icons/riserva/more.png" class="icona-bottone">
                        </button>
                    </form>
                </td>
            </tr>
        </table>
        <section id="sezione-home">
            <div id="msg-container">
                <div id="msg-prenotazione">Prenotazione effettuata con successo!
                    <div id="msg-riepilogo-prenotazione">
                        La prenotazione numero <?php echo $_SESSION['conferma_param']['numero']?> 
                        a nome <?php echo $_SESSION['conferma_param']['nome']." ".$_SESSION['conferma_param']['cognome'] ?> 
                        per la <?php echo $_SESSION['conferma_param']['stanza']?> dal 
                        <?php echo $_SESSION['conferma_param']['inizio']?> al 
                        <?php echo $_SESSION['conferma_param']['fine']?> è confermata al prezzo di <?php echo $_SESSION['conferma_param']['prezzo']?>€.
                    </div>
                </div>
                <aside id="msg-mail-prenotazione">
                    Una mail di conferma è stata inviata all'indirizzo 
                    <?php echo "<a href=\"".$_SESSION['conferma_param']['mail']."\">".$_SESSION['conferma_param']['mail']."</a>"?>.
                </aside>
            </div>
        </section>
        <footer id="footer-pagina-non-home">
            <a href="https://www.flaticon.com/free-icons/bed" title="bed icons">Bed icons created by Freepik - Flaticon</a>
            <a href="https://www.flaticon.com/free-icons/more" title="more icons">More icons created by Kirill Kazachek - Flaticon</a>
            <a href="https://www.flaticon.com/free-icons/home-button" title="home button icons">Home button icons created by Freepik - Flaticon</a>
            <a target="_blank" href="https://icons8.com/icon/uNhGg3MyjlpN/road">strada</a> icona di <a target="_blank" href="https://icons8.com">Icons8</a>
        </footer>
    </body>
</html>