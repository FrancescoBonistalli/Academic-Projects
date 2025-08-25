<?php

class DatiConfigurazione
{
    public $formuleVotiLaurea;
    public $listaEsamiInformatici;
    public $listaEsamiNonInMedia;
    public $messaggiEmail;
    public $notaFinaleProspetto;
    public $nomiComuniCdl;
    public $cfuCorsi;
    public $infoParametri;
    public $valoriLode;
    public $esamiNonCarriera;

    public function __construct(){
        //estrazione dati dal json
        $json = file_get_contents(__DIR__.  "/../data/FileConfigurazione/config.json");
        $arrayDatiConfig = json_decode($json, true);

        //inizializzazione della lista di formule per il calcolo del voto
        $this->formuleVotiLaurea = [];
        foreach ($arrayDatiConfig["infoCdL"] as $nomeCdl=>$datiConfigCorso){
            $this->formuleVotiLaurea[] = $nomeCdl;
            $this->formuleVotiLaurea[$nomeCdl] = $datiConfigCorso["formulaVoto"];
        }

        //inizializzazione della lista di esami informatici
        $this->listaEsamiInformatici = $arrayDatiConfig["esamiInformatici"];

        //inizializzazione della lista di esami in media
        $this->listaEsamiNonInMedia = [];
        foreach ($arrayDatiConfig["infoCdL"] as $nomeCdl=>$datiConfigCorso){
            $this->listaEsamiNonInMedia[] = $nomeCdl;
            $this->listaEsamiNonInMedia[$nomeCdl] = $datiConfigCorso["esamiNonInMedia"];
        }

        //inizializzazione della lista di messaggi per le email
        $this->messaggiEmail = [];
        foreach ($arrayDatiConfig["infoCdL"] as $nomeCdl=>$datiConfigCorso){
            $this->messaggiEmail[] = $nomeCdl;
            $this->messaggiEmail[$nomeCdl] = $datiConfigCorso["messaggioEmail"];
        }

        //inizializzazione della lista di note finali per i prospetti
        $this->notaFinaleProspetto = [];
        foreach ($arrayDatiConfig["infoCdL"] as $nomeCdl=>$datiConfigCorso){
            $this->notaFinaleProspetto[] = $nomeCdl;
            $this->notaFinaleProspetto[$nomeCdl] = $datiConfigCorso["messaggioProspetto"];
        }

        //inizializzazione lista nomi comuni cdl
        $this->nomiComuniCdl = [];
        foreach ($arrayDatiConfig["nomiComnuniCdl"] as $nomeCdl=>$datiConfigCorso){
            $this->nomiComuniCdl[] = $nomeCdl;
            $this->nomiComuniCdl[$nomeCdl] = $datiConfigCorso;
        }

        //inizializzazione cfu totali corsi di laurea
        $this->cfuCorsi = [];
        foreach ($arrayDatiConfig["infoCdL"] as $nomeCdl=>$datiConfigCorso){
            $this->cfuCorsi[] = $nomeCdl;
            $this->cfuCorsi[$nomeCdl] = $datiConfigCorso["totCfu"];
        }

        //inizializzazione info parametri
        $this->infoParametri = [];
        foreach ($arrayDatiConfig["infoCdL"] as $nomeCdl=>$datiConfigCorso){
            $this->infoParametri[] = $nomeCdl;
            $this->infoParametri[$nomeCdl] = $datiConfigCorso["infoParametro"];
        }
        //inizializzazione valori lode
        $this->valoriLode = [];
        foreach ($arrayDatiConfig["infoCdL"] as $nomeCdl=>$datiConfigCorso){
            $this->valoriLode[] = $nomeCdl;
            $this->valoriLode[$nomeCdl] = $datiConfigCorso["valoreLode"];
        }
        //inizializzazione esami non in carriera
        $this->esamiNonCarriera = [];
        foreach ($arrayDatiConfig["infoCdL"] as $nomeCdl=>$datiConfigCorso){
            $this->esamiNonCarriera[] = $nomeCdl;
            $this->esamiNonCarriera[$nomeCdl] = $datiConfigCorso["esamiNonInCarriera"];
        }
    }
    public function getFormulaVoto($cdl)
    {
        return $this->formuleVotiLaurea[$cdl];
    }

    public function getCfuCorso($cdl)
    {
        return $this->cfuCorsi[$cdl];
    }

    public function getInfoParametro($cdl)
    {
        return $this->infoParametri[$cdl];
    }

    public function getNotaFinale($cdl)
    {
        return $this->notaFinaleProspetto[$cdl];
    }

}