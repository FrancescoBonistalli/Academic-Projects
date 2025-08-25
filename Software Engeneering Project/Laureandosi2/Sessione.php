<?php

require_once "classes/InterfacciaGrafica.php";
session_start();

$_SESSION["stato"] = "";
$_SESSION["link"] = "";
$_SESSION["disabilitato"] = "disabled";

// Creazione prospetti
if (isset($_POST["cdl"], $_POST["data"], $_POST["matricole"], $_POST["crea"])) {
    $_SESSION["interfaccia"] = new InterfacciaGrafica($_POST["matricole"], $_POST["cdl"], $_POST["data"]);
        $_SESSION["interfaccia"]->generaProspettiLaurea();
        $_SESSION["link"] = $_SESSION["interfaccia"]->visualizzaProspettiLaurea();
        $_SESSION["stato"] = "Prospetti creati";
        $_SESSION["disabilitato"] = "";
}

// Invio prospetti
if (isset($_POST["invia"])) {
    $_SESSION["interfaccia"]->inviaProspettiLaurea();
    $_SESSION["link"] = $_SESSION["interfaccia"]->visualizzaProspettiLaurea();
}