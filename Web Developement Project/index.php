<?php
    session_start();
?>
<!DOCTYPE html>
<html lang="it">
    <head>
        <meta charset="utf-8">
        <title>Montefoscoli Hotel</title>
        <meta name="viewport" content="width=device-width" >
        <link rel="stylesheet" href="css/style2.css">
        <link rel="stylesheet" href="css/style3.css">
        <script src="js/caricamento-home.js"></script>
        <script src="js/credenziali.js"></script>
    </head>
    <body>
        <table id="tabella-home-page">
            <tr id="prima-riga-home">
                <td>
                    <img src="img/logo-prova.png" alt="img/riserva/logo-prova.png" id="logo">
                </td>
                <td id="scritta">
                    Hotel Montefoscoli
                </td>
                <td>
                    <?php
                        if (isset($_SESSION['login_ok']) && $_SESSION['login_ok'] == true){
                            echo "<form action=\"php/disconnetti.php\">
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
                    <form action="index.php" id="form-home">
                        <button id="tasto-home" class="bottoni-sezioni">
                            Home
                            <img src="img/icons/home.png" alt="img/icons/riserva/home.png" class="icona-bottone">
                        </button>
                    </form>
                </td>
                <td>
                    <form action="php/stanze.php">
                        <button id="tasto-camere" class="bottoni-sezioni">
                            Camere
                            <img src="img/icons/double-bed.png" alt="img/icons/riserva/double-bed.png" class="icona-bottone">
                        </button>
                    </form>   
                </td>
                <td>
                    <form action="php/altro.php">
                        <button id="tasto-altro" class="bottoni-sezioni">
                            Altro
                            <img src="img/icons/more.png" alt="img/icons/riserva/more.png" class="icona-bottone">
                        </button>
                    </form>
                </td>
            </tr>
        </table>
        <section id="sezione-home">
            <div id="panoramica-alloggi">
                <img src="img/icons/double-bed.png" alt="img/icons/riserva/double-bed.png">
                Il nostro hotel offre un’esperienza unica di relax e comfort, perfettamente integrata con la bellezza naturale dei dintorni.
                Le nostre stanze, ognuna con un carattere distintivo, combinano l'eleganza rustica con tutte le comodità moderne mentre le nostre Suite Panoramiche offrono grandi finestre con viste mozzafiato sui vigneti e oliveti circostanti.
                Per chi cerca un soggiorno più intimo, le nostre Camere sono perfette, con i loro accoglienti letti e soffitti con travi in legno a vista. Ogni camera è dotata di un’area salotto e di un balcone privato dove poter sorseggiare un bicchiere di vino ammirando il tramonto.
                Le nostre Camere Family sono ideali per chi viaggia con bambini, offrendo spazi ampi e confortevoli. Queste stanze sono arredate in stile rustico-chic e dispongono di tutte le comodità per un soggiorno rilassante.
            </div>
            <div id="attivita">
                <img src="img/icons/strada.png" alt="img/icons/riserva/strada.png">
                
                I nostri ospiti possono godere di numerosi percorsi pedonali e ciclabili che si snodano attraverso colline pittoresche e paesaggi incontaminati.
                Esplorate i sentieri panoramici, ideali per passeggiate rilassanti o per un’escursione in bicicletta. Ogni percorso vi porterà attraverso vigneti, oliveti e boschi, regalandovi scorci mozzafiato e l'opportunità di scoprire la flora e la fauna locale.
                Per i ciclisti più avventurosi, offriamo tour in mountain bike, che includono percorsi sfidanti e divertenti, perfetti per esplorare la campagna in modo attivo e dinamico.
                
                <footer>(I percorsi cosigliati dalla nostra struttura si trovano nella sezione "altro")</footer>
            </div>
        </section>
        <section id="sezione-reindirizzamento">
            <button onclick="location.href='html/documentazione.html'">Documentazione</button>
        </section>
        <footer id="footer-pagina">
            <a href="https://www.flaticon.com/free-icons/bed" title="bed icons">Bed icons created by Freepik - Flaticon</a>
            <a href="https://www.flaticon.com/free-icons/more" title="more icons">More icons created by Kirill Kazachek - Flaticon</a>
            <a href="https://www.flaticon.com/free-icons/home-button" title="home button icons">Home button icons created by Freepik - Flaticon</a>
            <a target="_blank" href="https://icons8.com/icon/uNhGg3MyjlpN/road">strada</a> icona di <a target="_blank" href="https://icons8.com">Icons8</a>
        </footer>
    </body>
</html>