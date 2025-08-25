<?php
/*
    Template name: Laureandosi
*/
require_once "Sessione.php";
?>

<!DOCTYPE html>
<html lang="it">
<head>
    <title>Generatore Prospetti di Laurea</title>
    <link rel="stylesheet" href="<?php echo get_stylesheet_directory_uri(); ?>/style.css">
</head>

<body>
<form method="post" action="<?php echo $_SERVER['REQUEST_URI']; ?>">
    <table>
        <tr id="riga1">
            <td colspan="3"><b>Generatore Prospetti di Laurea</b></td>
        </tr>
        <tr id="riga2">
            <td>
                <label class="info"><b>CdL:</b></label><br>
                <select name="cdl" style="font-size: 16px;" required>
                    <option value="">Seleziona un CdL</option>
                    <option value="INGEGNERIA BIOMEDICA (IBM-L)">T. Ing. Biomedica</option>
                    <option value="INGEGNERIA ELETTRONICA (IEL-L)">T. Ing. Elettronica</option>
                    <option value="INGEGNERIA INFORMATICA (IFO-L)">T. Ing. Informatica</option>
                    <option value="INGEGNERIA DELLE TELECOMUNICAZIONI (ITC-L)">T. Ing. delle Telecomunicazioni</option>
                    <option value="INGEGNERIA BIOMEDICA (WIB-LM), BIONICS ENGINEERING (WBE-LM)">M. Ing. Biomedica, Bionics Engineering</option>
                    <option value="INGEGNERIA ELETTRONICA (WIE-LM)">M. Ing. Elettronica</option>
                    <option value="COMPUTER ENGINEERING (WCN-LM), ARTIFICIAL INTELLIGENCE AND DATA ENGINEERING (WAI-LM)">M. Computer Engineering, Artificial Intelligence and Data Enginering</option>
                    <option value="INGEGNERIA ROBOTICA E DELL'AUTOMAZIONE (WIM-LM)">M. Ing. Robotica e della Automazione</option>
                    <option value="INGEGNERIA DELLE TELECOMUNICAZIONI (WIT-LM)">M. Ing. delle Telecomunicazioni</option>
                    <option value="CYBERSECURITY (WCY-LM)">M. Cybersecurity</option>
                </select><br><br><br><br>
                <label class="info"><b>Data di laurea: </b></label>
                <input type="date" name="data" required>
            </td>
            <td>
                <label class="info"><b>Matricole:</b></label><br>
                <textarea title="matricole" name="matricole"  style="font-size: 16px;" required></textarea>
            </td>
            <td>
                <button type="submit" name="crea">Crea Prospetti</button><br><br></form>
                <a href=<?php echo $_SESSION["link"];?> target="blank"><p>apri prospetti</p><br><br></a>
                <form method="post" action="<?php echo $_SERVER['REQUEST_URI']; ?>">
                    <button type="submit" name="invia" <?php echo $_SESSION["disabilitato"] ?>>Invia Prospetti</button>
                </form>
                <p style="color: red;"><?php echo $_SESSION["stato"] ?></p><br><br>
            </td>
        </form>
    </body>
</html>