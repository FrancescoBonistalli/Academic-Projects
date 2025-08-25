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
        <link rel="stylesheet" href="../css/style5.css">
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
            Selezionare uno dei tour per aprire il collegamento.
            <div id="tour-struttura">
                <a href="https://www.komoot.com/it-it/tour/1702281291" target="_blank" rel="nofollow noopener noreferrer"><img src="../img/tours/tour-camminata.png" alt="../img/tours/riserva/tour-camminata.png" width="640" height="700"></a>
                <a href="https://www.komoot.com/it-it/tour/1702284547" target="_blank" rel="nofollow noopener noreferrer"><img src="../img/tours/tour-bici.png" alt="../img/tours/riserva/tour-bici.png" width="640" height="700"></a>   
            </div>
            <div id="contatti">
                <h1>Contatti</h1>
                <a href="mailto:bonistalli641419@gmail.com">bonistalli641419@gmail.com</a>
                <a href="tel:+391234567890">+39 123 4567 890</a>
                Via Diotisalvi, 5, 56122 Pisa PI
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