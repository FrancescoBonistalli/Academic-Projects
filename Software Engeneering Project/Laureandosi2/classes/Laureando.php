<?php
require_once "DatiConfigurazione.php";
require_once "GestioneCarrieraStudente.php";
require_once "Esame.php";
require_once "globals.php";
class Laureando
{
    public $matricola;
    public $nome;
    public $cognome;
    public $email;
    public $cdl;
    public $esami;
    public $dataLaurea;
    public $dataIscrizione;

    public function __construct($matricola, $cdl, $test = false)
    {
        $this->matricola = $matricola;
        $gestioneCarrieraStudente = new GestioneCarrieraStudente();
        $datiConfigurazione = new DatiConfigurazione();
        if(!$test){
            $anagrafica = $gestioneCarrieraStudente->getAnagrafica($matricola);
            $carriera = $gestioneCarrieraStudente->getCarriera($matricola);
        }
        else {
            $anagrafica = $gestioneCarrieraStudente->getAnagraficaTest($matricola);
            $carriera = $gestioneCarrieraStudente->getCarrieraTest($matricola);
        }

        //inizializzazione dati anagrafici
        $this->nome = $anagrafica["nome"];
        $this->cognome = $anagrafica["cognome"];
        $this->email = $anagrafica["email_ate"];

        //inizializzazione dati carriera
        $this->cdl = $cdl;
        $this->dataIscrizione = strtotime(str_replace("/","-", $carriera[0]["INIZIO_CARRIERA"]));    //prende il dato dal primo esame
        foreach ($carriera as $esame){
            if($esame["CORSO"] == $this->cdl && !in_array($esame["DES"], $datiConfigurazione->esamiNonCarriera[$this->cdl])){
                $nuovoEsame = new Esame($esame["DES"], $esame["VOTO"], $esame["PESO"], $this->cdl, $esame["DATA_ESAME"]);
                if(in_array($nuovoEsame->nome, $datiConfigurazione->listaEsamiNonInMedia[$this->cdl])){
                    $nuovoEsame->inMedia = false;
                }
                $this->esami[$nuovoEsame->nome] = $nuovoEsame;
            }
        }

        //ordinamento esami
        uasort($this->esami, function ($a, $b) {
            $dataA = DateTime::createFromFormat('d/m/Y', $a->data);
            $dataB = DateTime::createFromFormat('d/m/Y', $b->data);

            return $dataA > $dataB;
        });
    }

    public function calcolaMediaPesata()
    {
        $sommaVotiPesati = 0;
        $sommaPesi = 0;
        foreach ($this->esami as $esame){
            if($esame->inMedia){
                $sommaVotiPesati += $esame->voto * $esame->cfu;
                $sommaPesi += $esame->cfu;
            }
        }
        return $sommaVotiPesati / $sommaPesi;
    }

    public function calcolaCfuMedia()
    {
        $sommaCfuInMedia = 0;
        foreach ($this->esami as $esame){
            if($esame->inMedia)
                $sommaCfuInMedia += $esame->cfu;
        }
        return $sommaCfuInMedia;
    }
    public function calcolaCfuCurriculari()
    {
        $cfuCurriculari = 0;
        foreach ($this->esami as $esame){
            $cfuCurriculari += $esame->cfu;
        }
        return $cfuCurriculari;
    }
}