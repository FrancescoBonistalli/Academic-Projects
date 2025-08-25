<?php

class Esame
{
    public $nome;
    public $voto;
    public $cfu;
    public $isInformatico;
    public $inMedia;
    public $cdl;
    public $data;

    public function __construct($nomeEsame, $votoEsame, $cfuEsame, $cdl, $data){
        $this->nome = $nomeEsame;
        $this->voto = $votoEsame;
        $this->cfu = $cfuEsame;
        $this->isInformatico = false; //default value
        $this->inMedia = true;  //default value

        $this->cdl = $cdl;
        $this->data = $data;

        $arrayVoto = explode(" ", $this->voto);

        if(in_array("lode", $arrayVoto)){
            $datiConf = new DatiConfigurazione();
            $valoreLode = $datiConf->valoriLode[$this->cdl];
            $this->voto = $valoreLode;
        }
    }
}