<?php
/*
Template Name: TEST
*/
require_once __DIR__."/classes/Test.php";

$test = new Test();
?>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Pagina di Test</title>
    <link rel="stylesheet" href="<?php echo get_stylesheet_directory_uri(); ?>/testStyle.css">
</head>
<body>
<div>
    <h1>Pagina di Test</h1>
    <?php
        $test->testAnagrafica();
        $stile = ($test->messaggioTest["esito"] != "eseguito correttamente") ? 'style="background-color: red;"' : '';
    ?>
    <div class = "test" <?php echo $stile?>>
        <?php

            $messaggio = $test->messaggioTest["nome"];
            $stato = $test->messaggioTest["esito"];
            $errore = $test->messaggioTest["errore"];

            echo $messaggio." - ".$stato."<br>"."Errori rilevati: ".$errore."<br>";
        ?>
    </div>
    <?php
        $test->testBonus();
        $stile = ($test->messaggioTest["esito"] != "eseguito correttamente") ? 'style="background-color: red;"' : '';
    ?>
    <div class = "test" <?php echo $stile?>>
        <?php

            $messaggio = $test->messaggioTest["nome"];
            $stato = $test->messaggioTest["esito"];
            $errore = $test->messaggioTest["errore"];

            echo $messaggio." - ".$stato."<br>"."Errori rilevati: ".$errore."<br>";
        ?>
    </div>
    <?php
    $test->testNumeriCarriera();
    $stile = ($test->messaggioTest["esito"] != "eseguito correttamente") ? 'style="background-color: red;"' : '';
    ?>
    <div class = "test" <?php echo $stile?>>
        <?php

        $messaggio = $test->messaggioTest["nome"];
        $stato = $test->messaggioTest["esito"];
        $errore = $test->messaggioTest["errore"];

        echo $messaggio." - ".$stato."<br>"."Errori rilevati: ".$errore."<br>";
        ?>
    </div>
    <?php
    $test->testCarriere();
    $stile = ($test->messaggioTest["esito"] != "eseguito correttamente") ? 'style="background-color: red;"' : '';
    ?>
    <div class = "test" <?php echo $stile?>>
        <?php

        $messaggio = $test->messaggioTest["nome"];
        $stato = $test->messaggioTest["esito"];
        $errore = $test->messaggioTest["errore"];

        echo $messaggio." - ".$stato."<br>"."Errori rilevati: ".$errore."<br>";
        ?>
    </div>
</div>
</body>
</html>
