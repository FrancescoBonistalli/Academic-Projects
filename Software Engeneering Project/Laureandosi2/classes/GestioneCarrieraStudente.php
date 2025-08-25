<?php

class GestioneCarrieraStudente
{
    public function getAnagrafica($matricola)
    {
        $json = file_get_contents(__DIR__.'/../data/AnagraficheStudenti/'.$matricola.'_anagrafica.json');
        $anagraficaArray = json_decode($json, true);
        return $anagraficaArray["Entries"]["Entry"];
    }
    public function getCarriera($matricola)
    {
        $json = file_get_contents(__DIR__."/../data/EsamiStudenti/".$matricola."_esami.json");
        $esamiArray = json_decode($json, true);
        return $esamiArray["Esami"]["Esame"];
    }

    public function getAnagraficaTest($matricola)
    {
        $json = file_get_contents(__DIR__.'/../data/AnagraficheTest/'.$matricola.'_anagrafica.json');
        $anagraficaArray = json_decode($json, true);
        return $anagraficaArray["Entries"]["Entry"];
    }

    public function getCarrieraTest($matricola)
    {
        $json = file_get_contents(__DIR__."/../data/EsamiTest/".$matricola."_esami.json");
        $anagraficaArray = json_decode($json, true);
        return $anagraficaArray["Esami"]["Esame"];
    }
}