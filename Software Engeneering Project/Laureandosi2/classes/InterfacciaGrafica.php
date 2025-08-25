<?php

require_once "ProspettoCommssione.php";
require_once "ProspettoLaureando.php";
require_once "GestoreEmail.php";
class InterfacciaGrafica
{
    public $cdl;
    public $dataLaurea;
    public $matricole;

    public function __construct($listaMatricole, $cdl, $dataLaurea)
    {
        $listaMatricole = str_replace(["\n", "\r"], " ", $listaMatricole);
        $this->matricole = explode(" ", $listaMatricole);
        $this->cdl = $cdl;
        $this->dataLaurea = $dataLaurea;
    }
    public function generaProspettiLaurea()
    {
        $prospettoCommissione = new ProspettoCommssione();

        foreach ($this->matricole as $matricola){
            $prospettoLaureando = new ProspettoLaureando($matricola, $this->dataLaurea, $this->cdl);
            $prospettoLaureando->generaPdfLaureando();
            $prospettoCommissione->aggiungiProspetto($prospettoLaureando);
        }

        $prospettoCommissione->generaPdfCommissione();
    }
    public function visualizzaProspettiLaurea()
    {
        return str_replace(
            " ",
            "%20",
                get_template_directory_uri() ."/data/Prospetti/$this->cdl/prospetto_commissione.pdf"
        );
    }

    public function inviaProspettiLaurea()
    {
        foreach ($this->matricole as $matricola){
            $gestoreMail = new GestoreEmail($matricola, $this->cdl);
            $gestoreMail->inviaEmail();
        }
    }
}