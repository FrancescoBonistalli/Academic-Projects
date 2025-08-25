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
        <link rel="stylesheet" href="../css/style4.css">
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
            <?php 
                require_once "DbParam.php";

                    
                    $connection = mysqli_connect(DBHOST, DBUSER, DBPW, DBNOME);

                    if(mysqli_connect_errno()){
                        exit("Connessione non riuscita (".mysqli_connect_error().")");
                    }
                    else{
                        //creazione dell'interfaccia di prenotazione delle camere contenute nel database
                        $query_stanze = "SELECT *
                                        FROM bonistalli_641419.Stanze";

                        $result_stanze = mysqli_query($connection, $query_stanze);

                        while($riga_stanze = mysqli_fetch_assoc($result_stanze)){
                            $nome_stanza = $riga_stanze["Nome"];
                            $posti_letto = $riga_stanze["Posti_letto"];
                            $prezzo_notte = $riga_stanze["Prezzo_notte"];

                            echo "<div id=\"div-" .$nome_stanza . "\">";
                                echo "<img src=\"../img/camere/".$nome_stanza. ".jpg\" alt=\"../img/camere/riserva/".$nome_stanza. ".jpg\">";
                                echo "<h1>".$nome_stanza."</h1>";
                                echo "<div>";
                                    echo "Posti letto: ".$posti_letto;
                                echo "</div>";
                                echo "<div>";
                                    echo "Prezzo a notte: ".$prezzo_notte."€";
                                echo "</div>";
                                echo "<form action=\"prenotazione.php\" method=\"post\" class=\"form-stanza\">";
                                    echo "<input type=\"hidden\" name=\"nome_stanza\" value=\"".$nome_stanza."\">";
                                    echo "<input type=\"hidden\" name=\"prezzo_notte\" value=\"".$prezzo_notte."\">";
                                    echo "Data check-in: "."<input type=\"date\" name=\"data-check-in\" id=\"data-inizio-".$nome_stanza."\">";
                                    echo "Data check-out: "."<input type=\"date\" name=\"data-check-out\" id=\"data-fine-".$nome_stanza."\">";
                                    echo "<button id=\"bottone-".$nome_stanza."\">Prenota</button>";
                                echo "</form>";
                            echo "</div>";
                        }

                        mysqli_close($connection);
                    }
            ?>
        </section>
        <footer id="footer-pagina-non-home">
            <a href="https://www.flaticon.com/free-icons/bed" title="bed icons">Bed icons created by Freepik - Flaticon</a>
            <a href="https://www.flaticon.com/free-icons/more" title="more icons">More icons created by Kirill Kazachek - Flaticon</a>
            <a href="https://www.flaticon.com/free-icons/home-button" title="home button icons">Home button icons created by Freepik - Flaticon</a>
        </footer>
    </body>
</html>