<?php

require_once "Laureando.php";
require_once "DatiConfigurazione.php";
class LaureandoIngInformatica extends Laureando
{
    public function __construct($matricola, $cdl, $test = false)
    {
        parent::__construct($matricola, $cdl, $test);
        $datiConfigurazione = new DatiConfigurazione();
        foreach ($this->esami as $esame){
            if(in_array($esame->nome, $datiConfigurazione->listaEsamiInformatici)){
                $this->esami[$esame->nome]->isInformatico = true;
            }
        }
    }

    public function verificaBonus()
    {
        $dataLaureaTime = strtotime($this->dataLaurea);
        if($dataLaureaTime - 3.6 * 365 * 86400 < $this->dataIscrizione) //differenza in secondi tra due dateTime
            return true;
        else
            return false;
    }

    public function calcolaMediaEsamiInformatici()
    {
        $sommaVotiPesati = 0;
        $sommaPesi = 0;
        foreach ($this->esami as $esame){
            if($esame->isInformatico && $esame->inMedia){
                $sommaVotiPesati += $esame->voto * $esame->cfu;
                $sommaPesi += $esame->cfu;
            }
        }
        return $sommaVotiPesati / $sommaPesi;
    }

    public function calcolaMediaPesata()
    {
        if($this->verificaBonus()){
            //ricerca esame voto minimo e tolto dalla media
            $votoMin = null;
            $esameMin = null;
            foreach ($this->esami as $esame){
                if(!isset($votoMin)){
                    $votoMin = $esame->voto;
                    $esameMin = $esame->nome;
                }
                else if( $esame->inMedia && $esame->voto < $votoMin ){
                    $votoMin = $esame->voto;
                    $esameMin = $esame->nome;
                }
                else if( $esame->inMedia && $esame->voto == $votoMin && $esame->cfu > $this->esami[$esameMin]->cfu){
                    $esameMin = $esame->nome;
                }
            }
            $this->esami[$esameMin]->inMedia = false;
        }

        $sommaVotiPesati = 0;
        $sommaPesi = 0;
        foreach ($this->esami as $esame){
            if($esame->inMedia){
                $sommaVotiPesati += $esame->voto * $esame->cfu;
//                $sommaVotiPesati += $valorePesato;
                $sommaPesi += $esame->cfu;
            }
        }
        return $sommaVotiPesati / $sommaPesi;
    }
}